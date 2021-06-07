//
//  PLSmsAuthPresenter.swift
//  PLLogin
//
//  Created by Juan Sánchez Marín on 28/5/21.
//

import DomainCommon
import Commons
import Models
import LoginCommon
import SANPLLibrary
import PLLegacyAdapter
import Security
import SwiftyRSA

protocol PLSmsAuthPresenterProtocol: MenuTextWrapperProtocol {
    var view: PLSmsAuthViewProtocol? { get set }
    var loginManager: PLLoginLayersManagerDelegate? { get set }
    func viewDidLoad()
    func viewWillAppear()
    func authenticate(smsCode: String)
    func recoverPasswordOrNewRegistration()
    func didSelectChooseEnvironment()
}

enum EncryptionError: Error {
    case emptyPublicKey
    case publicKeyGenerationFailed
}

final class PLSmsAuthPresenter {
    weak var view: PLSmsAuthViewProtocol?
    weak var loginManager: PLLoginLayersManagerDelegate?
    internal let dependenciesResolver: DependenciesResolver

    private var publicFilesEnvironment: PublicFilesEnvironmentEntity?

    init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
    }

    private var loginConfiguration: UnrememberedLoginConfiguration {
        self.dependenciesResolver.resolve(for: UnrememberedLoginConfiguration.self)
    }

    private var getPersistedPubKeyUseCase: PLGetPersistedPubKeyUseCase {
        self.dependenciesResolver.resolve(for: PLGetPersistedPubKeyUseCase.self)
    }

    private var authenticateInitUseCase: PLAuthenticateInitUseCase {
        self.dependenciesResolver.resolve(for: PLAuthenticateInitUseCase.self)
    }

    private var authenticateUseCase: PLAuthenticateUseCase {
        self.dependenciesResolver.resolve(for: PLAuthenticateUseCase.self)
    }
    
}

extension PLSmsAuthPresenter: PLSmsAuthPresenterProtocol {
    func viewDidLoad() {
        self.doAuthenticateInit()
    }

    func viewWillAppear() {
        self.loginManager?.getCurrentEnvironments()
    }

    func authenticate(smsCode: String) {
        self.doAuthenticate(smscode: smsCode)
    }

    func recoverPasswordOrNewRegistration() {
        // TODO
    }

    func didSelectChooseEnvironment() {
        // TODO
    }
}

extension PLSmsAuthPresenter: PLLoginPresenterLayerProtocol {
    func handle(event: LoginProcessLayerEvent) {
        // TODO
    }

    func handle(event: SessionProcessEvent) {
        // TODO
    }

    func willStartSession() {
        // TODO
    }

    func didLoadEnvironment(_ environment: PLEnvironmentEntity, publicFilesEnvironment: PublicFilesEnvironmentEntity) {
        self.publicFilesEnvironment = publicFilesEnvironment
        let wsViewModel = EnvironmentViewModel(title: environment.name, url: environment.urlBase)
        let publicFilesViewModel = EnvironmentViewModel(title: publicFilesEnvironment.name, url: publicFilesEnvironment.urlBase)
        self.view?.updateEnvironmentsText([wsViewModel, publicFilesViewModel])
    }
}

//MARK: - Private Methods
private extension  PLSmsAuthPresenter {
    var coordinator: PLSmsAuthCoordinatorProtocol {
        return self.dependenciesResolver.resolve(for: PLSmsAuthCoordinatorProtocol.self)
    }

    func doAuthenticateInit() {
        let caseInput: PLAuthenticateInitUseCaseInput = PLAuthenticateInitUseCaseInput(userId: loginConfiguration.userIdentifier, challenge: loginConfiguration.challenge)
        Scenario(useCase: self.authenticateInitUseCase, input: caseInput)
            .execute(on: self.dependenciesResolver.resolve())
            .onSuccess { _ in
                // TODO: connect sms timeout
            }
            .onError { error in

            }
    }

    func doAuthenticate(smscode: String) {
        let secondFactorData = SecondFactorDataAuthenticationEntity(challenge: loginConfiguration.challenge, value: smscode)
        guard let password = loginConfiguration.password else {
            // TODO: generate error, password can't be empty
            return
        }

        Scenario(useCase: self.getPersistedPubKeyUseCase)
            .execute(on: self.dependenciesResolver.resolve())
            .then(scenario: {  [weak self] (pubKeyOutput) -> Scenario<PLAuthenticateUseCaseInput, PLAuthenticateUseCaseOkOutput, PLAuthenticateUseCaseErrorOutput> in
                let encrytionKey = EncryptionKeyEntity(modulus: pubKeyOutput.modulus, exponent: pubKeyOutput.exponent)
                do {
                    let encryptedPassword = try self?.encryptPassword(password: password, encryptionKey: encrytionKey) ?? ""
                    let userId = self?.loginConfiguration.userIdentifier ?? ""

                    let caseInput: PLAuthenticateUseCaseInput = PLAuthenticateUseCaseInput(encryptedPassword: encryptedPassword, userId: userId, secondFactorData: secondFactorData)
                    return Scenario(useCase: self?.authenticateUseCase, input: caseInput)
                } catch {
                    // TODO: Show error message, the login process can't continue
                }

            })
            .onSuccess({ _ in
                // TODO: Navigate to PG
            })
            .onError { error in
                // TODO: Present error
            }
    }

    // MARK: Password encryption
    func encryptPassword(password: String, encryptionKey: EncryptionKeyEntity) throws -> String {
        guard let secPublicKey = self.getPublicKeySecurityRepresentation(encryptionKey.modulus, exponent: encryptionKey.exponent) else {
            throw EncryptionError.publicKeyGenerationFailed
        }
        var encryptedBase64String = ""
        let publicKey = try PublicKey(reference: secPublicKey)
        let clear = try ClearMessage(string: password, using: .utf8)
        let encrypted = try clear.encrypted(with: publicKey, padding: .PKCS1)
        encryptedBase64String = encrypted.base64String
      
        return encryptedBase64String
    }

    func getPublicKeySecurityRepresentation(_ modulus: String, exponent: String) -> SecKey? {
        var byteArrModulus = Array(modulus.utf8)
        let byteArrayExponent = Array(exponent.utf8)

        // Process modulus and exponent to generate an Apple Security SecKey
        byteArrModulus.insert(0x00, at: 0)

        var modulusEncoded: [UInt8] = []
        modulusEncoded.append(0x02)
        modulusEncoded.append(contentsOf: lengthField(of: byteArrModulus))
        modulusEncoded.append(contentsOf: byteArrModulus)

        var exponentEncoded: [UInt8] = []
        exponentEncoded.append(0x02)
        exponentEncoded.append(contentsOf: lengthField(of: byteArrayExponent))
        exponentEncoded.append(contentsOf: byteArrayExponent)

        var sequenceEncoded: [UInt8] = []
        sequenceEncoded.append(0x30)
        sequenceEncoded.append(contentsOf: lengthField(of: (modulusEncoded + exponentEncoded)))
        sequenceEncoded.append(contentsOf: (modulusEncoded + exponentEncoded))

        // Create the SecKey
        let keyData = Data(sequenceEncoded)
        let keySize = (byteArrModulus.count * 8)
        let attributes: [String: Any] = [
            kSecAttrKeyType as String: kSecAttrKeyTypeRSA,
            kSecAttrKeyClass as String: kSecAttrKeyClassPublic,
            kSecAttrKeySizeInBits as String: keySize
        ]
        let publicKey = SecKeyCreateWithData(keyData as CFData, attributes as CFDictionary, nil)

        return publicKey
    }

    func lengthField(of valueField: [UInt8]) -> [UInt8] {
        var count = valueField.count

        if count < 128 {
            return [ UInt8(count) ]
        }

        // The number of bytes needed to encode count.
        let lengthBytesCount = Int((log2(Double(count)) / 8) + 1)

        // The first byte in the length field encoding the number of remaining bytes.
        let firstLengthFieldByte = UInt8(128 + lengthBytesCount)

        var lengthField: [UInt8] = []
        for _ in 0..<lengthBytesCount {

            let lengthByte = UInt8(count & 0xff) // last 8 bits of count.
            lengthField.insert(lengthByte, at: 0)
            count = count >> 8 // Delete the last 8 bits of count.
        }

        // Include the first byte.
        lengthField.insert(firstLengthFieldByte, at: 0)
        return lengthField
    }
}

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
    func didSelectLoginRestartAfterTimeOut()
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

    private var encryptPasswordUseCase: PLPasswordEncryptionUseCase {
        self.dependenciesResolver.resolve(for: PLPasswordEncryptionUseCase.self)
    }
    
}

extension PLSmsAuthPresenter: PLSmsAuthPresenterProtocol {
    func didSelectLoginRestartAfterTimeOut() {
        // TODO
    }

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
        guard let password = loginConfiguration.password else {
            // TODO: generate error, password can't be empty
            return
        }

        Scenario(useCase: self.getPersistedPubKeyUseCase)
            .execute(on: self.dependenciesResolver.resolve())
            .then(scenario: {  [unowned self] (pubKeyOutput) -> Scenario<PLPasswordEncryptionUseCaseInput, PLPasswordEncryptionUseCaseOutput, PLAuthenticateUseCaseErrorOutput> in
                let encrytionKey = EncryptionKeyEntity(modulus: pubKeyOutput.modulus, exponent: pubKeyOutput.exponent)
                let useCaseInput = PLPasswordEncryptionUseCaseInput(plainPassword: password, encryptionKey: encrytionKey)
                return Scenario(useCase: self.encryptPasswordUseCase, input: useCaseInput)
            })
            .then(scenario: {  [unowned self] (encryptedPasswordOutput) -> Scenario<PLAuthenticateUseCaseInput, PLAuthenticateUseCaseOkOutput, PLAuthenticateUseCaseErrorOutput> in
                let secondFactorAuthentity = SecondFactorDataAuthenticationEntity(challenge: self.loginConfiguration.challenge, value: smscode)
                let useCaseInput = PLAuthenticateUseCaseInput(encryptedPassword: encryptedPasswordOutput.encryptedPassword, userId: self.loginConfiguration.userIdentifier, secondFactorData: secondFactorAuthentity)
                return Scenario(useCase: self.authenticateUseCase, input: useCaseInput)
            })
            .onSuccess({ _ in
                let coordinatorDelegate: PLLoginCoordinatorProtocol = self.dependenciesResolver.resolve(for: PLLoginCoordinatorProtocol.self)
                coordinatorDelegate.goToPrivate(.classic)
            })
            .onError { error in
                // TODO: Present errorsecondFactorData
            }
    }
}

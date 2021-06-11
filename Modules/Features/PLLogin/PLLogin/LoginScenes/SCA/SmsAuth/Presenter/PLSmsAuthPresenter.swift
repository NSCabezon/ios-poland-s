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

//        Scenario(useCase: self.getPersistedPubKeyUseCase)
//            .execute(on: self.dependenciesResolver.resolve())
//            .then(scenario: {  [weak self] (pubKeyOutput) -> Scenario<PLAuthenticateUseCaseInput, PLAuthenticateUseCaseOkOutput, PLAuthenticateUseCaseErrorOutput> in
//                let encrytionKey = EncryptionKeyEntity(modulus: pubKeyOutput.modulus, exponent: pubKeyOutput.exponent)
//                do {
//                    let encryptedPassword = try self?.encryptPassword(password: password, encryptionKey: encrytionKey) ?? ""
//                    let userId = self?.loginConfiguration.userIdentifier ?? ""
//
//                    let caseInput: PLAuthenticateUseCaseInput = PLAuthenticateUseCaseInput(encryptedPassword: encryptedPassword, userId: userId, secondFactorData: secondFactorData)
//                    return Scenario(useCase: self!.authenticateUseCase, input: caseInput) // WARNNING: force unwrap
//                } catch {
//                    return(PLAuthenticateUseCaseErrorOutput(error.localizedDescription))
//                }
//
//            })
//            .onSuccess({ _ in
//                // TODO: Navigate to PG
//            })
//            .onError { error in
//                // TODO: Present error
//            }
    }
}

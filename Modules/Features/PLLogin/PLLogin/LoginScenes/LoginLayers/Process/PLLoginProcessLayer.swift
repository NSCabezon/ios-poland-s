//
//  PLLoginProcessLayer.swift
//  PLLogin

import Commons
import PLCommons
import DomainCommon

public protocol PLLoginProcessLayerEventDelegate: AnyObject {
    func handle(event: LoginProcessLayerEvent)
    func handle(error: PLGenericError)
}

protocol PLLoginProcessLayerProtocol {
    func setDelegate(_ delegate: PLLoginProcessLayerEventDelegate)
    func setDemoUserIfNeeded(with loginType: LoginType, completion: @escaping () -> Void)
    func doLogin(with loginType: LoginType)
    func getPublicKey()
}

public class PLLoginProcessLayer {
    private let dependenciesResolver: DependenciesResolver
    private weak var delegate: PLLoginProcessLayerEventDelegate?

    private var useCaseHandler: UseCaseHandler {
        return self.dependenciesResolver.resolve(for: UseCaseHandler.self)
    }

    public init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
    }
}

extension PLLoginProcessLayer: PLLoginProcessLayerProtocol {
    public func setDelegate(_ delegate: PLLoginProcessLayerEventDelegate) {
        self.delegate = delegate
    }

    private var loginUseCase: PLLoginUseCase {
        self.dependenciesResolver.resolve(for: PLLoginUseCase.self)
    }

    private var getPublicKeyUseCase: PLGetPublicKeyUseCase {
        self.dependenciesResolver.resolve(for: PLGetPublicKeyUseCase.self)
    }

    func setDemoUserIfNeeded(with loginType: LoginType, completion: @escaping () -> Void) {
        let input = PLSetDemoUserUseCaseInput(userId: loginType.indentification)
        let setDemoUserUseCase = PLSetDemoUserUseCase(dependenciesResolver: self.dependenciesResolver)
        Scenario(useCase: setDemoUserUseCase, input: input)
            .execute(on: self.dependenciesResolver.resolve())
            .finally {
                completion()
            }
    }

    func doLogin(with loginType: LoginType) {
        self.delegate?.handle(event: .willLogin)
        switch loginType {
        case .notPersisted(let info):
            self.doNonPersistedLogin(info)
        case .persisted(let info):
            self.doPersistedLogin(info)
        }
    }

    func getPublicKey() {
        Scenario(useCase: self.getPublicKeyUseCase)
            .execute(on: self.dependenciesResolver.resolve())
            .onSuccess { _ in
                // Nothing to do
            }
            .onError { error in
                self.handleError(error)
            }
    }
}

//MARK: - Private Methods
private extension PLLoginProcessLayer {

    // MARK: Main login execution
    func doNonPersistedLogin(_ info: LoginTypeInfo) {
        let identifierType = self.getIdentifierType(info.identification)
        var caseInput: PLLoginUseCaseInput
        switch identifierType {
        case .nik:
            caseInput = PLLoginUseCaseInput(userId: info.identification, userAlias: nil)
        case .alias:
            caseInput = PLLoginUseCaseInput(userId: nil, userAlias: info.identification)
        }

        let useCase = self.loginUseCase.setRequestValues(requestValues: caseInput)
        guard let loginUseCase = useCase as? PLLoginUseCase else { return }
        Scenario(useCase: loginUseCase, input: caseInput)
            .execute(on: self.dependenciesResolver.resolve())
            .onSuccess { [weak self] output in
                var passwordType = PasswordType.normal
                if output.passwordMaskEnabled == true, let mask = output.passwordMask {
                    passwordType = PasswordType.masked(mask: mask)
                }
                let configuration = UnrememberedLoginConfiguration(userIdentifier: info.identification,
                                                                   passwordType: passwordType,
                                                                   challenge: ChallengeEntity(authorizationType: output.defaultChallenge.authorizationType, value: output.defaultChallenge.value),
                                                                   loginImageData: output.loginImage, password: nil, secondFactorDataFinalState: output.secondFactorFinalState, unblockRemainingTimeInSecs: output.unblockRemainingTimeInSecs)
                self?.delegate?.handle(event: .loginWithIdentifierSuccess(configuration: configuration))
            }
            .onError { [weak self] error in
                self?.handleError(error)
            }
    }

    func doPersistedLogin(_ info: LoginTypeInfo) {
        // TODO: Implement remembered login
    }

    // MARK: Auxiliar methods
    func handleError(_ error: UseCaseError<PLUseCaseErrorOutput<LoginErrorType>>?) {
        
        switch error {
        case .error(let error):
            guard let loginError = error?.getError() else {
                self.delegate?.handle(error: error?.genericError ?? .unknown)
                return
            }
            self.checkLoginError(loginError)
        case .networkUnavailable:
            self.delegate?.handle(error: .noConnection)
        case .unauthorized:
            self.delegate?.handle(event: .error(type: .unauthorized))
        case .generic, .intern, .none:
            self.delegate?.handle(event: .error(type: .unauthorized))
        }
    }

    func checkLoginError(_ error: LoginErrorType?) {
        switch error {
        case .temporaryLocked:
            self.delegate?.handle(event: .error(type: .temporaryLocked))
        default:
            self.delegate?.handle(event: .error(type: error ?? .unauthorized))
        }
    }

    // TODO: make a unit test
    /// Determines the identifier type depending on length and type. An Alias is alphanumeric and can have more than 8 characters
    func getIdentifierType(_ identifier: String) -> UserIdentifierType {
        let characters = CharacterSet.decimalDigits.inverted
        if !identifier.isEmpty && identifier.rangeOfCharacter(from: characters) == nil && identifier.count == 8 {
            return .nik
        } else {
            return .alias
        }
    }
}

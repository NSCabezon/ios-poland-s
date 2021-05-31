//
//  PLLoginProcessLayer.swift
//  PLLogin

import Commons
import DomainCommon

public protocol PLLoginProcessLayerEventDelegate: class {
    func handle(event: LoginProcessLayerEvent)
}

protocol PLLoginProcessLayerProtocol {
    func setDelegate(_ delegate: PLLoginProcessLayerEventDelegate)
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
                // TODO: Process error: without pub key we can't process SMS SCA
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
                                                                   challenge: LoginChallengeEntity(authorizationType: output.defaultChallenge.authorizationType, value: output.defaultChallenge.value),
                                                                   loginImageData: output.loginImage)
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
    func handleError<Error: PLLoginUseCaseErrorOutput>(_ error: UseCaseError<Error>?) {
        // TODO: Handle login errors
    }

    // TODO: make a unit test
    /// Determines the identifier type depending on length and type. An Alias is alphanumeric and can have more than 8 characters
    func getIdentifierType(_ identifier: String) -> UserIdentifierType {
        let characters = CharacterSet.decimalDigits.inverted
        if !identifier.isEmpty && identifier.rangeOfCharacter(from: characters) == nil && identifier.count <= 8 {
            return .nik
        } else {
            return .alias
        }

    }
}

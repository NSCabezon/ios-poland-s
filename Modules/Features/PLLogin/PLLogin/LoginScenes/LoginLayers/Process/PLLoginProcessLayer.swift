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
    func doAuthenticateInit()
    func doAuthenticate()
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

    private var authenticateInitUseCase: PLAuthenticateInitUseCase {
        self.dependenciesResolver.resolve(for: PLAuthenticateInitUseCase.self)
    }

    private var authenticateUseCase: PLAuthenticateUseCase {
        self.dependenciesResolver.resolve(for: PLAuthenticateUseCase.self)
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

    func doAuthenticateInit() {
        let caseInput: PLAuthenticateInitUseCaseInput = PLAuthenticateInitUseCaseInput(userId: "36548382", secondFactorData: SecondFactorDataEntity(defaultChallenge: DefaultChallengeEntity(authorizationType: "SMS_CODE", value: "48280441")))
        Scenario(useCase: self.authenticateInitUseCase, input: caseInput)
            .execute(on: self.dependenciesResolver.resolve())
            .onSuccess { _ in
                // Nothing to do
            }
            .onError { error in
                // TODO: Process error: without pub key we can't process SMS SCA
            }
    }

    func doAuthenticate() {
        let encryptedPassword = "7aa74fc9feda95f7c4e8ccc91f6e6e87de15107f272245716f1a5ebd003fd41295a54d3d607ecad99b7969818c5afdc675fb8a989c322a8dfe4f6ba94b188a5272aaa4547dff7e55f74be9774f4ba217e3d8e0fbbf341c18a82310d5c5ac26abf7eb62f73cd07d957f46f44bd716bd985a917af74e13ecd384fab4794382ebffa0426eced9e6af46d9f08b8b258637d20e4834cfde6b0c760e494efbf4026b62c93ae3aa76c943714b4625545e803c9c9b8c1bc01a2ebc4a991d8f83086e40f841423ae471c6f9378fb8139987467a9d708034c451d69ddf3bb614e07060b4a7ed9a5364d92fc1d3c2a135ed02c8296653a74414fabd5bb3c84f5006984c733d"

        let caseInput: PLAuthenticateUseCaseInput = PLAuthenticateUseCaseInput(encryptedPassword: encryptedPassword, userId: "36548382", secondFactorData: SecondFactorDataAuthenticateEntity(response: ResponseEntity(challenge: ChallengeEntity(authorizationType: "SMS_CODE", value: "48280441"), value: "217305")))
        Scenario(useCase: self.authenticateUseCase, input: caseInput)
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
                                                                   loginImageData: output.loginImage, password: nil)
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
        if !identifier.isEmpty && identifier.rangeOfCharacter(from: characters) == nil && identifier.count == 8 {
            return .nik
        } else {
            return .alias
        }

    }
}

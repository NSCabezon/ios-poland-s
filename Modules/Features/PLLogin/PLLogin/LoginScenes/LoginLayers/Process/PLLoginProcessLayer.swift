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
}

public class PLLoginProcessLayer {
    private let dependenciesResolver: DependenciesResolver
    private weak var delegate: PLLoginProcessLayerEventDelegate?

//    private var loginPTUseCase: PLLoginUseCase {
//        self.dependenciesResolver.resolve(for: PLLoginUseCase.self)
//    }
//    private var loginPTPersistedUseCase: PLLoginPersistedUseCase {
//        self.dependenciesResolver.resolve(for: PLLoginPersistedUseCase.self)
//    }
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

    func doLogin(with loginType: LoginType) {
        self.delegate?.handle(event: .willLogin)
        switch loginType {
        case .notPersisted(let info):
            self.doNonPersistedLogin(info)
        case .persisted(let info):
            self.doPersistedLogin(info)
        }
    }
}

//MARK: - Private Methods
private extension PLLoginProcessLayer {

    func doNonPersistedLogin(_ info: LoginTypeInfo) {
        // TODO
    }

    func doPersistedLogin(_ info: LoginTypeInfo) {
        // TODO
    }

    func loginWith<Input, Output, Error: PLLoginUseCaseErrorOutput>(useCase: UseCase<Input, Output, Error> & Cancelable, authLogin: AuthLogin) {
            UseCaseWrapper(
                with: useCase,
                useCaseHandler: self.useCaseHandler,
                onSuccess: { [weak self] _ in
                    self?.delegate?.handle(event: .loginSuccess)
                }, onError: { [weak self] error in
                    self?.handleError(error)
            })
    }

    func handleError<Error: PLLoginUseCaseErrorOutput>(_ error: UseCaseError<Error>?) {
        switch error {
        case .error(let error):
            self.checkLoginError(error?.loginErrorType)
        case .generic, .intern, .networkUnavailable, .unauthorized, .none:
            self.delegate?.handle(event: .loginError)
        }
    }

    func checkLoginError(_ error: PLLoginErrorType?) {
        switch error {
        case .temporaryLocked(let seconds):
            self.delegate?.handle(event: .accountTemporaryLocked(seconds: seconds))
        case .unauthorized:
            self.delegate?.handle(event: .wrongCredentials)
        case .termsAndConditions(let sessionId):
            self.delegate?.handle(event: .termsAndConditions(sessionId: sessionId))
        case .noConnection:
            self.delegate?.handle(event: .noConnection)
        case .sca(let sessionId):
            self.delegate?.handle(event: .sca(sessionId: sessionId))
        case .scaPhoneList(let sessionId, let phoneList):
            self.delegate?.handle(event: .scaPhoneList(sessionId: sessionId, phoneList: phoneList))
        default:
            self.delegate?.handle(event: .loginError)
        }
    }
}

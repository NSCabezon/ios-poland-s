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
        let input = PLLoginUseCaseInput(userId: info.identification, userAlias: <#T##String?#>)
        let useCase = self.loginUseCase.setRequestValues(requestValues: input)
        guard let loginUseCase = useCase as? LoginUseCase else { return }
        self.loginWith(useCase: loginUseCase, authLogin: .magic(magic ?? ""))
    }

    func doPersistedLogin(_ info: LoginTypeInfo) {
        // TODO
    }
}

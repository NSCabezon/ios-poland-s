//
//  PLAuthorizationCoordinator.swift
//  Santander
//
//  Created by Daniel Gómez Barroso on 28/10/21.
//

import UI
import Commons
import TransferOperatives
import OneAuthorizationProcessor
import CoreDomain
import PLLogin
import SANPLLibrary

public protocol PLAuthorizationCoordinatorProtocol {
    func dismiss()
    func start()
}

final class PLAuthorizationCoordinator: ModuleCoordinator {
    public weak var navigationController: UINavigationController?
    private let dependenciesEngine: DependenciesDefault

    public init(dependenciesResolver: DependenciesResolver, navigationController: UINavigationController?) {
        self.navigationController = navigationController
        self.dependenciesEngine = DependenciesDefault(father: dependenciesResolver)
        self.setupDependencies()
    }
    
    public func start() {
        let viewController = self.dependenciesEngine.resolve(for: PLAuthorizationViewController.self)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}

extension PLAuthorizationCoordinator: PLAuthorizationCoordinatorProtocol {
    func dismiss() {
        self.navigationController?.popViewController(animated: true)
    }
}

private extension PLAuthorizationCoordinator {
    func setupDependencies() {
        self.dependenciesEngine.register(for: PLAuthorizationCoordinatorProtocol.self) { _ in
            return self
        }
        self.dependenciesEngine.register(for: PLAuthorizationViewController.self) { resolver in
            let presenter = resolver.resolve(for: PLAuthorizationPresenterProtocol.self)
            let viewController = PLAuthorizationViewController(presenter: presenter)
            presenter.view = viewController
            return viewController
        }
        self.dependenciesEngine.register(for: PLAuthorizationPresenterProtocol.self) { resolver in
            return PLAuthorizationPresenter(dependenciesResolver: resolver)
        }
        self.dependenciesEngine.register(for: PLGetSecIdentityUseCase.self) { _ in
            return PLGetSecIdentityUseCase()
        }
        self.dependenciesEngine.register(for: PLTrustedDeviceGetStoredEncryptedUserKeyUseCase.self) { resolver in
            return PLTrustedDeviceGetStoredEncryptedUserKeyUseCase(dependenciesResolver: resolver)
        }
        self.dependenciesEngine.register(for: PLTrustedDeviceGetHeadersUseCase.self) { resolver in
            return PLTrustedDeviceGetHeadersUseCase(dependenciesResolver: resolver)
        }
        self.dependenciesEngine.register(for: PLLoginAuthorizationDataEncryptionUseCase.self) { resolver in
            return PLLoginAuthorizationDataEncryptionUseCase(dependenciesResolver: resolver)
        }
        self.dependenciesEngine.register(for: ConfirmPinUseCase.self) { resolver in
            return ConfirmPinUseCase(dependenciesResolver: resolver)
        }
    }
}

extension PLAuthorizationCoordinator: ChallengesHandlerDelegate {
    func handle(_ challenge: ChallengeRepresentable, authorizationId: String, completion: @escaping (ChallengeResult) -> Void) {
        guard let challenge = challenge as? PINChallengeRepresentable else { return completion(.notHandled) }
        self.dependenciesEngine.register(for: AuthorizationConfiguration.self) { _ in
            return AuthorizationConfiguration(authorizationId: authorizationId, challenge: challenge.challenge, softwareTokenKeys: challenge.softwareTokenKeys, completion: completion)
        }
        self.start()
    }
}

struct AuthorizationConfiguration {
    let authorizationId: String
    let challenge: String
    let softwareTokenKeys: [SoftwareTokenKeysDataDTO]
    let completion: (ChallengeResult) -> Void
}

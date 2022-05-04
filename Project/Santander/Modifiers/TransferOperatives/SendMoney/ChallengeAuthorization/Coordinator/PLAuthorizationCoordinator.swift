//
//  PLAuthorizationCoordinator.swift
//  Santander
//
//  Created by Daniel Gómez Barroso on 28/10/21.
//

import UI
import CoreFoundationLib
import TransferOperatives
import OneAuthorizationProcessor
import CoreDomain
import SANPLLibrary
import PLCommons
import BLIK

public protocol PLAuthorizationCoordinatorProtocol {
    func dismiss()
    func start()
}

final class PLAuthorizationCoordinator: ModuleCoordinator {
    public weak var navigationController: UINavigationController?
    private let dependenciesEngine: DependenciesDefault
    private var progressTotalTime: Float?
    
    public init(dependenciesResolver: DependenciesResolver, navigationController: UINavigationController?) {
        self.navigationController = navigationController
        self.dependenciesEngine = DependenciesDefault(father: dependenciesResolver)
        self.setupDependencies()
    }
    
    public func start() {
        let viewController = self.dependenciesEngine.resolve(for: PLAuthorizationViewController.self)
        viewController.presenter.updateRemainingProgressTime(progressTotalTime)
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
            let viewController = PLAuthorizationViewController(dependenciesResolver: resolver,
                                                               presenter: presenter)
            presenter.view = viewController
            return viewController
        }
        self.dependenciesEngine.register(for: PLAuthorizationPresenterProtocol.self) { resolver in
            return PLAuthorizationPresenter(dependenciesResolver: resolver)
        }
        self.dependenciesEngine.register(for: PLGetSecIdentityUseCase<StringErrorOutput>.self) { _ in
            return PLGetSecIdentityUseCase<StringErrorOutput>()
        }
        self.dependenciesEngine.register(for: PLTrustedDeviceGetStoredEncryptedUserKeyUseCase<StringErrorOutput>.self) { resolver in
            return PLTrustedDeviceGetStoredEncryptedUserKeyUseCase<StringErrorOutput>(dependenciesResolver: resolver)
        }
        self.dependenciesEngine.register(for: PLTrustedDeviceGetHeadersUseCase<StringErrorOutput>.self) { resolver in
            return PLTrustedDeviceGetHeadersUseCase<StringErrorOutput>(dependenciesResolver: resolver)
        }
        self.dependenciesEngine.register(for: PLAuthorizationDataEncryptionUseCase<StringErrorOutput>.self) { resolver in
            return PLAuthorizationDataEncryptionUseCase<StringErrorOutput>(dependenciesResolver: resolver)
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

extension PLAuthorizationCoordinator: BlikChallengesHandlerDelegate {
    func handle(
        _ challenge: ChallengeRepresentable,
        authorizationId: String,
        progressTotalTime: Float?,
        completion: @escaping (ChallengeResult) -> Void
    ) {
        self.progressTotalTime = progressTotalTime
        handle(challenge, authorizationId: authorizationId, completion: completion)
    }
}

struct AuthorizationConfiguration {
    let authorizationId: String
    let challenge: String
    let softwareTokenKeys: [SoftwareTokenKeysDataDTO]
    let completion: (ChallengeResult) -> Void
}

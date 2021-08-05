//
//  VoiceBotCoordinator.swift
//  PLLogin
//
//  Created by Juan Sánchez Marín on 29/7/21.
//

import UI
import Models
import Commons

protocol PLVoiceBotCoordinatorProtocol {
    func goToHardwareToken()
}

final class PLVoiceBotCoordinator: ModuleCoordinator {
    weak var navigationController: UINavigationController?
    private let dependenciesEngine: DependenciesDefault

    init(dependenciesResolver: DependenciesResolver, navigationController: UINavigationController?) {
        self.navigationController = navigationController
        self.dependenciesEngine = DependenciesDefault(father: dependenciesResolver)
        self.setupDependencies()
    }

    func start() {
        let controller = self.dependenciesEngine.resolve(for: PLVoiceBotViewController.self)
        self.navigationController?.pushViewController(controller, animated: true)
    }
}

extension PLVoiceBotCoordinator: PLVoiceBotCoordinatorProtocol {
    func goToHardwareToken() {
        //TODO:
    }
}

/**
 Register Scene depencencies.
*/
private extension PLVoiceBotCoordinator {
    func setupDependencies() {
        self.dependenciesEngine.register(for: PLVoiceBotCoordinatorProtocol.self) { _ in
            return self
        }

        self.dependenciesEngine.register(for: PLVoiceBotPresenterProtocol.self) { resolver in
            return PLVoiceBotPresenter(dependenciesResolver: resolver)
        }

        self.dependenciesEngine.register(for: PLVoiceBotViewController.self) { resolver in
            var presenter = resolver.resolve(for: PLVoiceBotPresenterProtocol.self)
            let viewController = PLVoiceBotViewController(
                nibName: "PLVoiceBotViewController",
                bundle: .module,
                presenter: presenter)
            presenter.view = viewController
            return viewController
        }
    }
}


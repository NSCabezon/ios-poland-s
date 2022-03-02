//
//  PLTermsAndConditionsCoordinator.swift
//  PLLogin
//
//  Created by Juan Sánchez Marín on 7/2/22.
//

import UI
import CoreFoundationLib

public struct PLTermsAndConditionsConfiguration {
    let title: String
    let description: String
}

protocol PLTermsAndConditionsCoordinatorDelegate {
    func onRejectTerms()
    func onAcceptTerms()
}

protocol PLTermsAndConditionsCoordinatorProtocol {
    func startWith(configuration: PLTermsAndConditionsConfiguration)
    func rejectTerms()
    func acceptTerms()
}

final class PLTermsAndConditionsCoordinator: ModuleCoordinator {
    
    var navigationController: UINavigationController?
    internal let dependenciesEngine: DependenciesResolver & DependenciesInjector
    var delegate: PLTermsAndConditionsCoordinatorDelegate?

    init(dependenciesResolver: DependenciesResolver,
         delegate: PLTermsAndConditionsCoordinatorDelegate,
         navigationController: UINavigationController?) {
        self.navigationController = navigationController
        self.delegate = delegate
        self.dependenciesEngine = DependenciesDefault(father: dependenciesResolver)
        self.setupDependencies()
    }
    func start() {
        //missing configuration
    }
}

extension PLTermsAndConditionsCoordinator: PLTermsAndConditionsCoordinatorProtocol {
    
    func acceptTerms() {
        self.delegate?.onAcceptTerms()
    }
    
    func rejectTerms() {
        self.delegate?.onRejectTerms()
    }
    
    func startWith(configuration: PLTermsAndConditionsConfiguration) {
        let controller = self.dependenciesEngine.resolve(for: PLTermsAndConditionsViewController.self)
        controller.configuration = configuration
        self.navigationController?.present(controller, animated: true)
    }
}

private extension PLTermsAndConditionsCoordinator {
    func setupDependencies() {
        let presenter = PLTermsAndConditionsPresenter(dependenciesResolver: self.dependenciesEngine)

        self.dependenciesEngine.register(for: PLTermsAndConditionsCoordinatorProtocol.self) { _ in
            return self
        }

        self.dependenciesEngine.register(for: PLTermsAndConditionsPresenterProtocol.self) { _ in
            return presenter
        }
        
        self.dependenciesEngine.register(for: PLRememberedLoginChangeUserUseCase.self) { resolver in
            return PLRememberedLoginChangeUserUseCase(dependenciesResolver: resolver)
        }

        self.dependenciesEngine.register(for: PLTermsAndConditionsViewProtocol.self) { dependenciesResolver in
            return dependenciesResolver.resolve(for: PLTermsAndConditionsViewController.self)
        }
        self.dependenciesEngine.register(for: PLTermsAndConditionsViewController.self) { resolver in
            var presenter = resolver.resolve(for: PLTermsAndConditionsPresenterProtocol.self)
            let viewController = PLTermsAndConditionsViewController(
                nibName: "PLTermsAndConditionsViewController",
                bundle: Bundle.module,
                dependenciesResolver: resolver,
                presenter: presenter)
            viewController.modalPresentationStyle = .fullScreen
            presenter.view = viewController
            return viewController
        }
    }
}

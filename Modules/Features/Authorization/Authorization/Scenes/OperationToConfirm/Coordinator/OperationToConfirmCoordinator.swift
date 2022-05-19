//
//  OperationToConfirmCoordinator.swift
//  Authorization
//
//  Created by 186484 on 14/04/2022.
//

import UI
import CoreFoundationLib

protocol OperationToConfirmCoordinatorProtocol: ModuleCoordinator {
    var onCloseConfirmed: (() -> Void)? { get set }
    func goBack()
    func close()
}

final class OperationToConfirmCoordinator: OperationToConfirmCoordinatorProtocol {
    weak var navigationController: UINavigationController?
    private let dependenciesEngine: DependenciesDefault
    var onCloseConfirmed: (() -> Void)?

    init(dependenciesResolver: DependenciesResolver, navigationController: UINavigationController?) {
        self.navigationController = navigationController
        self.dependenciesEngine = DependenciesDefault(father: dependenciesResolver)
        self.setupDependencies()
    }
    
    func start() {
        let controller = self.dependenciesEngine.resolve(for: OperationToConfirmViewController.self)
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func goBack() {
        navigationController?.popViewController(animated: true)
    }
    
    func close() {
        navigationController?.popToRootViewController(animated: true)
    }
}

private extension OperationToConfirmCoordinator {
    func setupDependencies() {
        self.dependenciesEngine.register(for: OperationToConfirmCoordinatorProtocol.self) { _ in
            return self
        }
         
        self.dependenciesEngine.register(for: OperationToConfirmPresenterProtocol.self) { resolver in
            return OperationToConfirmPresenter(dependenciesResolver: resolver)
        }
         
        self.dependenciesEngine.register(for: OperationToConfirmViewController.self) { resolver in
            let presenter = resolver.resolve(for: OperationToConfirmPresenterProtocol.self)
            let viewController = OperationToConfirmViewController(presenter: presenter)
            presenter.view = viewController
            return viewController
        }
    }
}


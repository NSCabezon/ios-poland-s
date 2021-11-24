//
//  CharityTransferConfirmationCoordinator.swift
//  CharityTransfer
//
//  Created by 187830 on 08/11/2021.
//

import UI
import Commons

public protocol CharityTransferConfirmationCoordinatorProtocol {
    func pop()
    func backToTransfer()
}

public final class CharityTransferConfirmationCoordinator: ModuleCoordinator {
    public weak var navigationController: UINavigationController?
    private let dependenciesEngine: DependenciesDefault
    private let model: CharityTransferModel

    init(dependenciesResolver: DependenciesResolver,
         navigationController: UINavigationController?,
         model: CharityTransferModel) {
        self.dependenciesEngine = DependenciesDefault(father: dependenciesResolver)
        self.navigationController = navigationController
        self.model = model
        setupDependencies()
    }
    
    public func start() {
        let controller =  dependenciesEngine.resolve(for: CharityTransferConfirmationViewController.self)
        navigationController?.pushViewController(controller, animated: true)
    }
}

private extension CharityTransferConfirmationCoordinator {
    func setupDependencies() {
        dependenciesEngine.register(for: CharityTransferConfirmationCoordinatorProtocol.self) { _ in
            self
        }
        dependenciesEngine.register(for: CharityTransferConfirmationPresenterProtocol.self) { [weak self] resolver in
            CharityTransferConfirmationPresenter(dependenciesResolver: resolver, model: self?.model)
        }
        dependenciesEngine.register(for: CharityTransferConfirmationViewController.self) { resolver in
            var presenter = resolver.resolve(for: CharityTransferConfirmationPresenterProtocol.self)
            let viewController =  CharityTransferConfirmationViewController(
                presenter: presenter
            )
            presenter.view = viewController
            return viewController
        }
    }
}

extension CharityTransferConfirmationCoordinator: CharityTransferConfirmationCoordinatorProtocol {

    public func pop() {
        navigationController?.popViewController(animated: true)
    }

    public func backToTransfer() {
        if let viewController = navigationController?.viewControllers.reversed()[safe: 2] {
            navigationController?.popToViewController(viewController, animated: true)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
}


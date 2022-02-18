//
//  CharityTransferModuleCoordinator.swift
//  Account
//
//  Created by 187125 on 03/01/2022.
//

import UI
import CoreFoundationLib
import SANPLLibrary
import PLCommons
import PLUI

public protocol CharityTransferModuleCoordinatorProtocol {
    func close()
    func showCharityTransferForm(with accounts: [AccountForDebit], selectedAccountNumber: String)
    func showCharityAccountSelector(with accounts: [AccountForDebit])
}

public final class CharityTransferModuleCoordinator: CharityTransferModuleCoordinatorProtocol {
    public var navigationController: UINavigationController?
    private let dependenciesEngine: DependenciesDefault
    private var charityTransferSettings: CharityTransferSettings

    public init(
        dependenciesResolver: DependenciesResolver,
        charityTransferSettings: CharityTransferSettings,
        navigationController: UINavigationController?
    ) {
        self.navigationController = navigationController
        self.dependenciesEngine = DependenciesDefault(father: dependenciesResolver)
        self.charityTransferSettings = charityTransferSettings
        self.setUpDependencies()
    }

    public func start() {
        let controller = self.dependenciesEngine.resolve(for: CharityTransferModuleViewController.self)
        navigationController?.pushViewController(controller, animated: true)
    }
    
    public func close() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    public func showCharityTransferForm(with accounts: [AccountForDebit], selectedAccountNumber: String) {
        let coordinator = CharityTransferFormCoordinator(
            dependenciesResolver: dependenciesEngine,
            navigationController: navigationController,
            accounts: accounts,
            selectedAccountNumber: selectedAccountNumber,
            charityTransferSettings: charityTransferSettings
        )
        coordinator.start()
        removeModuleControllerFromStack()
    }
    
    public func showCharityAccountSelector(with accounts: [AccountForDebit]) {
        let coordinator = CharityTransferAccountSelectorCoordinator(
            dependenciesResolver: dependenciesEngine,
            navigationController: navigationController,
            accounts: accounts,
            selectedAccountNumber: "",
            sourceView: .sendMoney,
            charityTransferSettings: charityTransferSettings
        )
        coordinator.start()
        removeModuleControllerFromStack()
    }
}

private extension CharityTransferModuleCoordinator {
    func removeModuleControllerFromStack() {
        let firstIndex = navigationController?.viewControllers.firstIndex {
            $0 is CharityTransferModuleViewController
        }
        guard let count = navigationController?.viewControllers.count,
              let index = firstIndex,
              count > index else { return }
        
        navigationController?.viewControllers.remove(at: index)
    }
    
    func setUpDependencies() {
        dependenciesEngine.register(for: CharityTransferModuleCoordinatorProtocol.self) { _ in
            self
        }
        dependenciesEngine.register(for: CharityTransferModulePresenterProtocol.self) { resolver in
            CharityTransferModulePresenter(dependenciesResolver: resolver)
        }
        dependenciesEngine.register(for: CharityTransferModuleViewController.self) { resolver in
            let presenter = resolver.resolve(for: CharityTransferModulePresenterProtocol.self)
            let viewController = CharityTransferModuleViewController(presenter: presenter)
            presenter.view = viewController
            return viewController
        }
    }
}

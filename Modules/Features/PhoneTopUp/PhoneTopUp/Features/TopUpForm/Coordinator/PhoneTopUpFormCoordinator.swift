//
//  PhoneTopUpCoordinator.swift
//  PhoneTopUp
//
//  Created by 188216 on 19/11/2021.
//
import UI
import Commons
import PLCommons
import PLUI

protocol PhoneTopUpFormCoordinatorProtocol: AnyObject {
    func back()
    func close()
    func didSelectChangeAccount(availableAccounts: [AccountForDebit], selectedAccountNumber: String?)
}

public final class PhoneTopUpFormCoordinator: ModuleCoordinator {
    
    // MARK: Properties
    
    public var navigationController: UINavigationController?
    private let dependenciesEngine: DependenciesDefault
    private weak var accountSelectorDelegate: AccountSelectorDelegate?
    
    // MARK: Lifecycle
    
    public init(dependenciesResolver: DependenciesResolver,
                navigationController: UINavigationController?) {
        self.navigationController = navigationController
        self.dependenciesEngine = DependenciesDefault(father: dependenciesResolver)
        self.setUpDependencies()
    }
    
    // MARK: Methods
    
    public func start() {
        let controller = self.dependenciesEngine.resolve(for: PhoneTopUpFormViewController.self)
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    private func setUpDependencies() {
        self.dependenciesEngine.register(for: PhoneTopUpFormCoordinatorProtocol.self) { _ in
            return self
        }
        self.dependenciesEngine.register(for: PhoneTopUpFormPresenterProtocol.self) { resolver in
            return PhoneTopUpFormPresenter(dependenciesResolver: resolver)
        }
        self.dependenciesEngine.register(for: PhoneTopUpFormViewController.self) { [weak self] resolver in
            let presenter = resolver.resolve(for: PhoneTopUpFormPresenterProtocol.self)
            let viewController = PhoneTopUpFormViewController(presenter: presenter)
            presenter.view = viewController
            self?.accountSelectorDelegate = presenter
            return viewController
        }
        self.dependenciesEngine.register(for: ConfirmationDialogProducing.self) { _ in
            return ConfirmationDialogFactory()
        }
        self.dependenciesEngine.register(for: SelectableAccountViewModelMapping.self) { _ in
            return SelectableAccountViewModelMapper(amountFormatter: .PLAmountNumberFormatter)
        }
    }
}

extension PhoneTopUpFormCoordinator: PhoneTopUpFormCoordinatorProtocol {
    func back() {
        navigationController?.popViewController(animated: true)
    }
    
    func close() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    func didSelectChangeAccount(availableAccounts: [AccountForDebit], selectedAccountNumber: String?) {
        let accountSelectorCoordinator = AccountSelectorCoordinator(dependenciesResolver: dependenciesEngine,
                                                                    navigationController: navigationController,
                                                                    accounts: availableAccounts,
                                                                    selectedAccountNumber: selectedAccountNumber,
                                                                    accountSelectorDelegate: self)
        accountSelectorCoordinator.start()
    }
}

extension PhoneTopUpFormCoordinator: AccountSelectorDelegate {
    func accountSelectorDidSelectAccount(withAccountNumber accountNumber: String) {
        accountSelectorDelegate?.accountSelectorDidSelectAccount(withAccountNumber: accountNumber)
    }
}

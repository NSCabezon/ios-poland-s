//
//  ZusTransferFormCoordinator.swift
//  ZusTransfer
//
//  Created by 187830 on 14/12/2021.
//

import UI
import CoreFoundationLib
import Commons
import SANPLLibrary
import PLCommons
import PLUI

protocol ZusTransferFormCoordinatorProtocol {
    func pop()
    func closeProcess()
    func showAccountSelector(selectedAccountNumber: String)
}

public protocol FormAccountSelectable: AnyObject {
    func updateSelectedAccountNumber(number: String)
}

public final class ZusTransferFormCoordinator: ModuleCoordinator {
    public var navigationController: UINavigationController?
    private let dependenciesEngine: DependenciesDefault
    private let accounts: [AccountForDebit]
    private let selectedAccountNumber: String
    weak var delegate: ZusTransferFormAccountSelectable?

    public init(
        dependenciesResolver: DependenciesResolver,
        navigationController: UINavigationController?,
        accounts: [AccountForDebit],
        selectedAccountNumber: String
    ) {
        self.navigationController = navigationController
        self.dependenciesEngine = DependenciesDefault(father: dependenciesResolver)
        self.accounts = accounts
        self.selectedAccountNumber = selectedAccountNumber
        setupDependencies()
    }
    
    public func start() {
        let controller = self.dependenciesEngine.resolve(for: ZusTransferFormViewController.self)
        navigationController?.pushViewController(controller, animated: true)
    }
}

extension ZusTransferFormCoordinator: ZusTransferFormCoordinatorProtocol {
    func pop() {
        navigationController?.popViewController(animated: true)
    }
    
    func closeProcess() {
        //TODO: change po to back to Send Money when will be available
        navigationController?.popToRootViewController(animated: true)
    }
    
    func showAccountSelector(selectedAccountNumber: String) {
        let coordinator = ZusAccountSelectorCoordinator(
            dependenciesResolver: dependenciesEngine,
            navigationController: navigationController,
            accounts: accounts,
            selectedAccountNumber: selectedAccountNumber,
            sourceView: .form,
            selectableAccountDelegate: self
        )
        coordinator.start()
    }
}

private extension ZusTransferFormCoordinator {
    func setupDependencies() {
        dependenciesEngine.register(for: ZusTransferValidating.self) { _ in
            ZusTransferValidator()
        }
        dependenciesEngine.register(for: ConfirmationDialogProducing.self) { _ in
            ConfirmationDialogFactory()
        }
        dependenciesEngine.register(for: SelectableAccountViewModelMapping.self) { _ in
            SelectableAccountViewModelMapper(amountFormatter: .PLAmountNumberFormatter)
        }
        dependenciesEngine.register(for: ZusTransferFormCoordinatorProtocol.self) { _ in
            self
        }
        
        let accounts = accounts
        let selectedAccountNumber = selectedAccountNumber
        
        dependenciesEngine.register(for: ZusTransferFormPresenterProtocol.self) { resolver in
            ZusTransferFormPresenter(
                dependenciesResolver: resolver,
                accounts: accounts,
                selectedAccountNumber: selectedAccountNumber
            )
        }
        dependenciesEngine.register(for: ZusTransferFormViewController.self) { [weak self] resolver in
            var presenter = resolver.resolve(for: ZusTransferFormPresenterProtocol.self)
            self?.delegate = presenter as? ZusTransferFormPresenter
            let viewController = ZusTransferFormViewController(presenter: presenter)
            presenter.view = viewController
            return viewController
        }
    }
}

extension ZusTransferFormCoordinator: FormAccountSelectable {
    public func updateSelectedAccountNumber(number: String) {
        delegate?.updateSelectedAccountNumber(number: number)
    }
}
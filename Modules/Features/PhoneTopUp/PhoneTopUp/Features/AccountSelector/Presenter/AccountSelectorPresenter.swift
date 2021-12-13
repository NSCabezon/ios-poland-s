//
//  AccountCoordinatorPresenter.swift
//  PLUI
//
//  Created by 188216 on 26/11/2021.
//

import Models
import Commons
import PLUI
import PLCommons

final class AccountSelectorPresenter {
    weak var view: AccountSelectorViewProtocol?
    private let dependenciesResolver: DependenciesResolver
    private let accounts: [AccountForDebit]
    private var selectedAccountNumber: String?
    private let accountMapper: SelectableAccountViewModelMapping
    private let confirmationDialogFactory: ConfirmationDialogProducing = ConfirmationDialogFactory()
    private weak var accountSelectorDelegate: AccountSelectorDelegate?

    init(dependenciesResolver: DependenciesResolver,
         accounts: [AccountForDebit],
         selectedAccountNumber: String?,
         accountSelectorDelegate: AccountSelectorDelegate?) {
        self.dependenciesResolver = dependenciesResolver
        self.accounts = accounts
        self.selectedAccountNumber = selectedAccountNumber
        self.accountMapper = dependenciesResolver.resolve(for: SelectableAccountViewModelMapping.self)
        self.accountSelectorDelegate = accountSelectorDelegate
    }
}

private extension AccountSelectorPresenter {
    var coordinator: AccountSelectorCoordinatorProtocol {
        return self.dependenciesResolver.resolve()
    }
}

extension AccountSelectorPresenter: AccountSelectorPresenterProtocol {
    func didSelectAccount(at index: Int) {
        accountSelectorDelegate?.accountSelectorDidSelectAccount(withAccountNumber: accounts[index].number)
        didPressClose()
    }
    
    func didPressClose() {
        coordinator.pop()
    }
    
    func viewDidLoad() {
        let accoutViewModels = accounts.compactMap({ try? accountMapper.map($0, selectedAccountNumber: selectedAccountNumber) })
        view?.setViewModels(accoutViewModels)
    }
    
    func didCloseProcess() {
        let dialog = confirmationDialogFactory.createEndProcessDialog {[weak self] in
            self?.coordinator.closeProcess()
        }
        declineAction: {}
        
        view?.showDialog(dialog)
    }
}

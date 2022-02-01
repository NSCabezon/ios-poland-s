//
//  AccountSelectorPresenter.swift
//  BLIK
//
//  Created by Piotr Mielcarzewicz on 29/07/2021.
//

import CoreFoundationLib
import PLUI
import PLCommons

final class AccountSelectorPresenter: AccountSelectorPresenterProtocol {
    private let dependenciesResolver: DependenciesResolver
    private var coordinator: AccountSelectorCoordinatorProtocol {
        dependenciesResolver.resolve()
    }
    private var viewModelMapper: BlikCustomerAccountToSelectableAccountViewModelMapping {
        dependenciesResolver.resolve()
    }
    private var accounts: [BlikCustomerAccount]
    private let selectedAccountNumber: String
    private var useCaseHandler: UseCaseHandler {
        return self.dependenciesResolver.resolve(for: UseCaseHandler.self)
    }
    weak var view: AccountSelectorViewProtocol?
    
    init(
        dependenciesResolver: DependenciesResolver,
        accounts: [BlikCustomerAccount],
        selectedAccountNumber: String
    ) {
        self.dependenciesResolver = dependenciesResolver
        self.accounts = accounts
        self.selectedAccountNumber = selectedAccountNumber
    }
    
    func viewDidLoad() {
        displayAccounts()
    }
    
    func didSelectAccount(at index: Int) {
        coordinator.selectAccount(accounts[index])
    }
    
    func didPressClose() {
        coordinator.close()
    }

    private func displayAccounts() {
        let viewModels = viewModelMapper.map(accounts: accounts, selectedAccountNumber: selectedAccountNumber)
        view?.setViewModels(viewModels)
    }
}

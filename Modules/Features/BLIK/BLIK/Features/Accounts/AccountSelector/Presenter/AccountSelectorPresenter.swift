//
//  AccountSelectorPresenter.swift
//  BLIK
//
//  Created by Piotr Mielcarzewicz on 29/07/2021.
//

import Commons
import DomainCommon
import PLUI
import PLCommons

final class AccountSelectorPresenter: AccountSelectorPresenterProtocol {
    private let dependenciesResolver: DependenciesResolver
    private var coordinator: AccountSelectorCoordinatorProtocol {
        dependenciesResolver.resolve()
    }
    private var viewModelMapper: SelectableAccountViewModelMapping {
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
        do {
            let viewModels = try accounts.map { acc -> SelectableAccountViewModel in
                let debitAcc = AccountForDebit(
                    id: acc.id,
                    name: acc.name,
                    number: acc.number,
                    availableFunds: acc.availableFunds,
                    defaultForPayments: acc.defaultForPayments,
                    type: .OTHER,
                    accountSequenceNumber: -1,
                    accountType: -1
                )
                // TODO:- Replace this mapper with a dedicated viewModel mapper that takes [BlikCustomerAccount] as an input
                // Currently `SelectableAccountViewModel` depends on API model that have `type`, `accountSequenceNumber` and `accountType` parameters
                // They shouldn't be included in this viewModel, because it makes `SelectableAccountView` dependent on specific API endpoint
                let viewModel = try viewModelMapper.map(debitAcc)
                return getViewModelWithLatestSelectedAccount(from: viewModel)
            }
            view?.setViewModels(viewModels)
        } catch {
            view?.showServiceInaccessibleMessage(onConfirm: { [weak self] in
                self?.coordinator.close()
            })
        }
    }
    
    // TODO:- Replace this function with proper mapper after `SelectableAccountViewModel` will be decoupled from API-specific fields
    private func getViewModelWithLatestSelectedAccount(
        from viewModel: SelectableAccountViewModel
    ) -> SelectableAccountViewModel {
        return SelectableAccountViewModel(
            name: viewModel.name,
            accountNumber: viewModel.accountNumber,
            accountNumberUnformatted: viewModel.accountNumberUnformatted,
            availableFunds: viewModel.availableFunds,
            type: viewModel.type,
            accountSequenceNumber: viewModel.accountSequenceNumber,
            accountType: viewModel.accountType,
            isSelected: viewModel.accountNumberUnformatted == selectedAccountNumber
        )
    }
}

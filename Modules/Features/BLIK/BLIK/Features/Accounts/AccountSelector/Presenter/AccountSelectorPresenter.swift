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
    private let coordinator: AccountSelectorCoordinatorProtocol
    private let loadAccountsUseCase: LoadCustomerAccountsUseCaseProtocol
    private let viewModelMapper: SelectableAccountViewModelMapping
    private var fetchedAccounts: [AccountForDebit] = []
    private var useCaseHandler: UseCaseHandler {
        return self.dependenciesResolver.resolve(for: UseCaseHandler.self)
    }
    weak var view: AccountSelectorViewProtocol?
    
    init(
        dependenciesResolver: DependenciesResolver,
        coordinator: AccountSelectorCoordinatorProtocol,
        loadAccountsUseCase: LoadCustomerAccountsUseCaseProtocol,
        viewModelMapper: SelectableAccountViewModelMapping
    ) {
        self.dependenciesResolver = dependenciesResolver
        self.coordinator = coordinator
        self.loadAccountsUseCase = loadAccountsUseCase
        self.viewModelMapper = viewModelMapper
    }
    
    func viewDidLoad() {
        view?.showLoader()
        Scenario(useCase: loadAccountsUseCase)
            .execute(on: useCaseHandler)
            .onSuccess { [weak self] accounts in
                self?.fetchedAccounts = accounts
                self?.view?.hideLoader(completion: {
                    self?.displayFetchedAccounts()
                })
            }
            .onError { [weak self] error in
                self?.view?.hideLoader(completion: {
                    self?.showErrorMessage()
                })
            }
    }
    
    func didSelectAccount(at index: Int) {
        coordinator.selectAccount(fetchedAccounts[index])
    }
    
    func didPressClose() {
        coordinator.close()
    }

    private func displayFetchedAccounts() {
        do {
            let viewModels = try fetchedAccounts.map {
                try viewModelMapper.map($0)
            }
            view?.setViewModels(viewModels)
        } catch {
            showErrorMessage()
        }
    }
    
    private func showErrorMessage() {
        let message = "#Nie udało się pobrać listy kont. Spróbuj pononownie później."
        view?.showErrorMessage(message, onConfirm: nil)
    }
}

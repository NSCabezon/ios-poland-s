//
//  AccountChooseListPresenter.swift
//  Pods
//
//  Created by 186484 on 04/06/2021.
//  

import Models
import Commons
import CoreFoundationLib

protocol AccountChooseListPresenterProtocol: MenuTextWrapperProtocol {
    var view: AccountChooseListViewProtocol? { get set }

    func viewDidLoad()
    func didConfirmClosing()
    func backButtonSelected()
    func didSelectItem(at indexPath: IndexPath)
}

final class AccountChooseListPresenter {
    weak var view: AccountChooseListViewProtocol?
    let dependenciesResolver: DependenciesResolver
    
    var accountEntities: [CCRAccountEntity] = []

    init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
    }
    
    private var getAccountsUseCase: GetAccountsUseCase {
        return dependenciesResolver.resolve(for: GetAccountsUseCase.self)
    }
    
    private lazy var formManager: CreditCardRepaymentFormManager =
        dependenciesResolver.resolve(for: CreditCardRepaymentFormManager.self)
}

private extension AccountChooseListPresenter {
    var coordinator: AccountChooseListCoordinatorProtocol {
        return self.dependenciesResolver.resolve(for: AccountChooseListCoordinatorProtocol.self)
    }
}

extension AccountChooseListPresenter: AccountChooseListPresenterProtocol {
    
    func viewDidLoad() {
        loadAccounts()
    }
    
    func didSelectItem(at indexPath: IndexPath) {
        formManager.setAccount(accountEntities[indexPath.item])
        reloadData()
        coordinator.goBack()
    }
    
    func didConfirmClosing() {
        coordinator.onCloseConfirmed?()
    }
    
    func backButtonSelected() {
        coordinator.goBack()
    }
    
    private func loadAccounts() {
        Scenario(useCase: getAccountsUseCase)
            .execute(on: dependenciesResolver.resolve())
            .onSuccess { [weak self] result in
                guard let self = self else { return }
                self.accountEntities = result.accounts
                self.reloadData()
            }
            .onError { [weak self] _ in
                guard let self = self else { return }
                self.view?.showError(
                    closeAction: { [weak self] in
                        self?.coordinator.goBack()
                    }
                )
            }
    }
    
    private func reloadData() {
        let accounts = accountEntities.map {
            AccountChooseListViewModel(
                accountName: $0.alias,
                accountAmount: $0.availableAmount.getFormattedDisplayValueAndCurrency(with: NumberFormatter.PLAmountNumberFormatterWithoutCurrency),
                isSelected: self.formManager.form.account == $0
            )
        }
        view?.setup(with: accounts)
    }

}

extension AccountChooseListPresenter: AutomaticScreenActionTrackable {
    var trackerPage: AccountChooseListPage {
        AccountChooseListPage()
    }
    var trackerManager: TrackerManager {
        self.dependenciesResolver.resolve(for: TrackerManager.self)
    }
}

//TODO:
//Change it in future
public struct AccountChooseListPage: PageWithActionTrackable {
    public typealias ActionType = Action
    public let page = "examplePage"
    
    public enum Action: String {
        case apply = "example"
    }
    public init() {}
}

//
//  PhoneTopUpPresenter.swift
//  PhoneTopUp
//
//  Created by 188216 on 24/11/2021.
//

import Commons
import Foundation
import PLCommons
import PLUI

protocol PhoneTopUpFormPresenterProtocol: AccountSelectorDelegate {
    var view: PhoneTopUpFormViewProtocol? { get set }
    func viewDidLoad()
    func didSelectBack()
    func didSelectClose()
    func didSelectChangeAccount()
}

final class PhoneTopUpFormPresenter {
    // MARK: Properties
    
    weak var view: PhoneTopUpFormViewProtocol?
    private weak var coordinator: PhoneTopUpFormCoordinatorProtocol?
    private let confirmationDialogFactory: ConfirmationDialogProducing
    private let accountMapper: SelectableAccountViewModelMapping
    private let dependenciesResolver: DependenciesResolver
    private var selectedAccountNumber: String?
    
    #warning("todo: remove mock")
    private var mockAccounts = [
        AccountForDebit(id: "", name: "Konto godne polecenia", number: "022344534534534", availableFunds: Money(amount: 10000.0, currency: "PLN"), defaultForPayments: true, type: .DEPOSIT, accountSequenceNumber: 0, accountType: 2),
        AccountForDebit(id: "", name: "Konto godne polecenia 2", number: "122344534534534", availableFunds: Money(amount: 10000.0, currency: "PLN"), defaultForPayments: false, type: .DEPOSIT, accountSequenceNumber: 0, accountType: 2),
    ]
    
    // MARK: Lifecycle
    
    init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
        coordinator = dependenciesResolver.resolve(for: PhoneTopUpFormCoordinatorProtocol.self)
        confirmationDialogFactory = dependenciesResolver.resolve(for: ConfirmationDialogProducing.self)
        accountMapper = dependenciesResolver.resolve(for: SelectableAccountViewModelMapping.self)
        selectedAccountNumber = mockAccounts.first(where: \.defaultForPayments)?.number
    }
}

// MARK: PhoneTopUpFormPresenterProtocol
extension PhoneTopUpFormPresenter: PhoneTopUpFormPresenterProtocol {
    func viewDidLoad() {
        let viewModels = mockAccounts.compactMap({ try? accountMapper.map($0, selectedAccountNumber: selectedAccountNumber) })
        view?.updateSelectedAccount(with: viewModels)
    }
    
    func didSelectBack() {
        coordinator?.back()
    }
    
    func didSelectClose() {
        let dialog = confirmationDialogFactory.createEndProcessDialog { [weak self] in
            self?.coordinator?.close()
        } declineAction: {}
        view?.showDialog(dialog)
        coordinator?.close()
    }
    
    func accountSelectorDidSelectAccount(withAccountNumber accountNumber: String) {
        selectedAccountNumber = accountNumber
        let viewModels = mockAccounts.compactMap({ try? accountMapper.map($0, selectedAccountNumber: selectedAccountNumber) })
        view?.updateSelectedAccount(with: viewModels)
    }
    
    func didSelectChangeAccount() {
        coordinator?.didSelectChangeAccount(availableAccounts: mockAccounts, selectedAccountNumber: selectedAccountNumber)
    }
}

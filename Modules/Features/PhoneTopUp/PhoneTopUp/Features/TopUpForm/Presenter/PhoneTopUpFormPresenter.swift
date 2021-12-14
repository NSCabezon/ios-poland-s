//
//  PhoneTopUpPresenter.swift
//  PhoneTopUp
//
//  Created by 188216 on 24/11/2021.
//

import Commons
import PLCommons
import Commons
import PLUI
import CoreFoundationLib
import SANPLLibrary
import SANLegacyLibrary


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
    private let accounts: [AccountForDebit]
    private let dependenciesResolver: DependenciesResolver
    private weak var coordinator: PhoneTopUpFormCoordinatorProtocol?
    private let confirmationDialogFactory: ConfirmationDialogProducing
    private let accountMapper: SelectableAccountViewModelMapping
    private let useCase: GetPhoneTopUpFormDataUseCaseProtocol
    private var selectedAccountNumber: String?
    private let useCaseHandler: UseCaseHandler
    
    // MARK: Lifecycle
    
    init(dependenciesResolver: DependenciesResolver, accounts: [AccountForDebit]) {
        self.dependenciesResolver = dependenciesResolver
        self.accounts = accounts
        coordinator = dependenciesResolver.resolve(for: PhoneTopUpFormCoordinatorProtocol.self)
        confirmationDialogFactory = dependenciesResolver.resolve(for: ConfirmationDialogProducing.self)
        accountMapper = dependenciesResolver.resolve(for: SelectableAccountViewModelMapping.self)
        selectedAccountNumber = accounts.first(where: \.defaultForPayments)?.number
        self.useCase = dependenciesResolver.resolve(for: GetPhoneTopUpFormDataUseCaseProtocol.self)
        self.useCaseHandler = dependenciesResolver.resolve(for: UseCaseHandler.self)
    }
}

// MARK: PhoneTopUpFormPresenterProtocol
extension PhoneTopUpFormPresenter: PhoneTopUpFormPresenterProtocol {
    func viewDidLoad() {
        let viewModels = accounts.compactMap({ try? accountMapper.map($0, selectedAccountNumber: selectedAccountNumber) })
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
        let viewModels = accounts.compactMap({ try? accountMapper.map($0, selectedAccountNumber: selectedAccountNumber) })
        view?.updateSelectedAccount(with: viewModels)
    }
    
    func didSelectChangeAccount() {
        coordinator?.didSelectChangeAccount(availableAccounts: accounts, selectedAccountNumber: selectedAccountNumber)
    }
}

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


protocol PhoneTopUpFormPresenterProtocol: AccountSelectorDelegate, InternetContactsDelegate {
    var view: PhoneTopUpFormViewProtocol? { get set }
    func viewDidLoad()
    func didSelectBack()
    func didSelectClose()
    func didSelectChangeAccount()
    func didTouchContactsButton()
    func didInputPartialPhoneNumber(_ number: String)
    func didInputFullPhoneNumber(_ number: String)
}

final class PhoneTopUpFormPresenter {
    // MARK: Properties
    
    weak var view: PhoneTopUpFormViewProtocol?
    private let accounts: [AccountForDebit]
    private let operators: [Operator]
    private let gsmOperators: [GSMOperator]
    private let dependenciesResolver: DependenciesResolver
    private weak var coordinator: PhoneTopUpFormCoordinatorProtocol?
    private let confirmationDialogFactory: ConfirmationDialogProducing
    private let accountMapper: SelectableAccountViewModelMapping
    private let useCase: GetPhoneTopUpFormDataUseCaseProtocol
    private var selectedAccountNumber: String?
    private let useCaseHandler: UseCaseHandler
    
    // MARK: Lifecycle
    
    init(dependenciesResolver: DependenciesResolver,
         accounts: [AccountForDebit],
         operators: [Operator],
         gsmOperators: [GSMOperator]) {
        self.dependenciesResolver = dependenciesResolver
        self.accounts = accounts
        self.operators = operators
        self.gsmOperators = gsmOperators
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
    
    func didTouchContactsButton() {
        coordinator?.didTouchContactsButton()
    }
    
    func didInputPartialPhoneNumber(_ number: String) {
        view?.showOperatorSelection(with: nil)
    }
    
    func didInputFullPhoneNumber(_ number: String) {
        if let matchingOperator = matchOperator(with: number) {
            view?.showInvalidPhoneNumberError(false)
            view?.showOperatorSelection(with: matchingOperator)
        } else {
            view?.showInvalidPhoneNumberError(true)
            view?.showOperatorSelection(with: nil)
        }
    }
    
    func internetContactsDidSelectContact(_ contact: MobileContact) {
        view?.updatePhoneInput(with: contact.phoneNumber)
        didInputFullPhoneNumber(contact.phoneNumber.filter(\.isNumber))
    }
    
    private func matchOperator(with number: String) -> Operator? {
        return operators.first(where: { $0.prefixes.first(where: { number.starts(with: $0) }) != nil })
    }
}
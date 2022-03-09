//
//  PhoneTopUpCoordinator.swift
//  PhoneTopUp
//
//  Created by 188216 on 19/11/2021.
//
import UI
import Contacts
import CoreFoundationLib
import PLCommons
import PLUI
import PLCommonOperatives

protocol PhoneTopUpFormCoordinatorProtocol: AnyObject {
    func back()
    func close()
    func didSelectChangeAccount(availableAccounts: [AccountForDebit], selectedAccountNumber: String?)
    func showInternetContacts()
    func showPhoneContacts(_ contacts: [MobileContact])
    func showTopUpConfirmation(with summary: TopUpModel)
    func showOperatorSelection(currentlySelectedOperatorId operatorId: Int?)
}

final class PhoneTopUpFormCoordinator: ModuleCoordinator {
    // MARK: Properties
    
    var navigationController: UINavigationController?
    private let dependenciesEngine: DependenciesDefault
    private let formData: TopUpPreloadedFormData
    private weak var accountSelectorDelegate: AccountForDebitSelectorDelegate?
    private weak var contactsSelectorDelegate: MobileContactsSelectorDelegate?
    private weak var operatorSelectorDelegate: OperatorSelectorDelegate?
    
    private lazy var phoneTopUpController = dependenciesEngine.resolve(for: PhoneTopUpFormViewController.self)
    
    // MARK: Lifecycle
    
    init(dependenciesResolver: DependenciesResolver,
                navigationController: UINavigationController?,
                formData: TopUpPreloadedFormData) {
        self.navigationController = navigationController
        self.dependenciesEngine = DependenciesDefault(father: dependenciesResolver)
        self.formData = formData
        self.setUpDependencies()
    }
    
    // MARK: Dependencies
    
    private func setUpDependencies() {
        self.dependenciesEngine.register(for: PaymentAmountCellViewModelMapping.self) { _ in
            return PaymentAmountCellViewModelMapper()
        }

        self.dependenciesEngine.register(for: CustomTopUpAmountValidating.self) { _ in
            return CustomTopUpAmountValidator()
        }
        
        self.dependenciesEngine.register(for: PartialPhoneNumberValidating.self) { _ in
            return PartialPhoneNumberValidator()
        }

        self.dependenciesEngine.register(for: ContactsPermissionHelperProtocol.self) { _ in
            return ContactsPermissionHelper()
        }
        
        dependenciesEngine.register(for: PolishContactsFiltering.self) { _ in
            return PolishContactsFilter()
        }
        
        self.dependenciesEngine.register(for: ContactMapping.self) { _ in
            return ContactMapper()
        }
        
        self.dependenciesEngine.register(for: TopUpFormValidating.self) { resolver in
            let customAmountValidator = resolver.resolve(for: CustomTopUpAmountValidating.self)
            let phoneNumberValidator = resolver.resolve(for: PartialPhoneNumberValidating.self)
            return TopUpFormValidator(customAmountValidator: customAmountValidator, numberValidator: phoneNumberValidator)
        }
        
        self.dependenciesEngine.register(for: GetContactsUseCaseProtocol.self) { resolver in
            return GetContactsUseCase(contactStore: CNContactStore(), contactMapper: resolver.resolve(for: ContactMapping.self))
        }
        
        self.dependenciesEngine.register(for: PhoneTopUpFormCoordinatorProtocol.self) { _ in
            return self
        }
        self.dependenciesEngine.register(for: PhoneTopUpFormPresenterProtocol.self) { [formData] resolver in
            return PhoneTopUpFormPresenter(dependenciesResolver: resolver,
                                           accounts: formData.accounts,
                                           operators: formData.operators,
                                           gsmOperators: formData.gsmOperators,
                                           internetContacts: formData.internetContacts,
                                           settings: formData.settings,
                                           topUpAccount: formData.topUpAccount)
        }
        self.dependenciesEngine.register(for: PhoneTopUpFormViewController.self) { [weak self] resolver in
            let presenter = resolver.resolve(for: PhoneTopUpFormPresenterProtocol.self)
            let viewController = PhoneTopUpFormViewController(presenter: presenter)
            presenter.view = viewController
            self?.accountSelectorDelegate = presenter
            self?.contactsSelectorDelegate = presenter
            self?.operatorSelectorDelegate = presenter
            return viewController
        }
        self.dependenciesEngine.register(for: ConfirmationDialogProducing.self) { _ in
            return ConfirmationDialogFactory()
        }
        self.dependenciesEngine.register(for: SelectableAccountViewModelMapping.self) { _ in
            return SelectableAccountViewModelMapper(amountFormatter: .PLAmountNumberFormatter)
        }
        
        self.dependenciesEngine.register(for: GetPhoneTopUpFormDataUseCaseProtocol.self) { resolver in
            return GetPhoneTopUpFormDataUseCase(dependenciesResolver: resolver)
        }
        
        self.dependenciesEngine.register(for: AccountForDebitMapping.self) { _ in
            return AccountForDebitMapper()
        }
    }
    
    // MARK: Methods
    
    func start() {
        let selectedAccount = formData.accounts.first(where: \.defaultForPayments)
        guard selectedAccount != nil else {
            self.navigationController?.replaceTopViewController(with: phoneTopUpController, animated: true)
            showAccountSelector(availableAccounts: formData.accounts, selectedAccountNumber: nil, mode: .mustSelectDefaultAccount)
            return
        }
        
        self.navigationController?.replaceTopViewController(with: phoneTopUpController, animated: false)
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
        showAccountSelector(availableAccounts: availableAccounts, selectedAccountNumber: selectedAccountNumber, mode: .changeDefaultAccount)
    }
    
    func showAccountSelector(
        availableAccounts: [AccountForDebit],
        selectedAccountNumber: String?,
        mode: AccountForDebitSelectorMode
    ) {
        let coordinator = AccountForDebitSelectorCoordinator(
            dependenciesResolver: dependenciesEngine,
            navigationController: navigationController,
            mode: mode,
            accounts: availableAccounts,
            screenLocationConfiguration: .phoneTopUp,
            selectedAccountNumber: selectedAccountNumber,
            accountSelectorDelegate: self
        )
        coordinator.start()
    }
    
    func showInternetContacts() {
        let internetContactsCoordinator = InternetContactsCoordinator(dependenciesResolver: dependenciesEngine,
                                                                      delegate: self,
                                                                      navigationController: navigationController,
                                                                      contacts: formData.internetContacts)
        internetContactsCoordinator.start()
    }
    
    func showPhoneContacts(_ contacts: [MobileContact]) {
        let phoneContactsCoordinator = PhoneContactsCoordinator(dependenciesResolver: dependenciesEngine,
                                                                delegate: self,
                                                                navigationController: navigationController,
                                                                contacts: contacts)
        phoneContactsCoordinator.start()
    }
    
    func showTopUpConfirmation(with summary: TopUpModel) {
        let confirmationCoordinator = TopUpConfirmationCoordinator(dependenciesResolver: dependenciesEngine,
                                                    navigationController: navigationController,
                                                    summary: summary)
        confirmationCoordinator.start()
    }
    
    func showOperatorSelection(currentlySelectedOperatorId operatorId: Int?) {
        let operatorSelectionCoordinator = OperatorSelectionCoordinator(dependenciesResolver: dependenciesEngine,
                                                                        delegate: self,
                                                                        navigationController: navigationController,
                                                                        operators: formData.operators,
                                                                        gsmOperators: formData.gsmOperators,
                                                                        selectedOperatorId: operatorId)
        operatorSelectionCoordinator.start()
    }
    
    private func showContactsPermissionDeniedDialog() {
        guard let navigationController = navigationController else {
            return
        }

        let dialog = ContactsPermissionDeniedDialogBuilder().buildDialog()
        dialog.showIn(navigationController)
    }
}

extension PhoneTopUpFormCoordinator: AccountForDebitSelectorDelegate {
    func didSelectAccount(withAccountNumber accountNumber: String) {
        accountSelectorDelegate?.didSelectAccount(withAccountNumber: accountNumber)
    }
}

extension PhoneTopUpFormCoordinator: MobileContactsSelectorDelegate {
    func mobileContactsDidSelectContact(_ contact: MobileContact) {
        navigationController?.popToViewController(phoneTopUpController, animated: true)
        contactsSelectorDelegate?.mobileContactsDidSelectContact(contact)
    }
    
    func mobileContactDidSelectCloseProcess() {
        navigationController?.popToViewController(phoneTopUpController, animated: true)
    }
}

extension PhoneTopUpFormCoordinator: OperatorSelectorDelegate {
    func didSelectOperator(_ gsmOperator: GSMOperator) {
        navigationController?.popToViewController(phoneTopUpController, animated: true)
        operatorSelectorDelegate?.didSelectOperator(gsmOperator)
    }
}

//
//  PhoneTopUpCoordinator.swift
//  PhoneTopUp
//
//  Created by 188216 on 19/11/2021.
//
import UI
import Commons
import PLCommons
import PLUI
import PLCommonOperatives

protocol PhoneTopUpFormCoordinatorProtocol: AnyObject {
    func back()
    func close()
    func didSelectChangeAccount(availableAccounts: [AccountForDebit], selectedAccountNumber: String?)
    func didTouchContactsButton()
}

public final class PhoneTopUpFormCoordinator: ModuleCoordinator {
    
    // MARK: Properties
    
    public var navigationController: UINavigationController?
    private let dependenciesEngine: DependenciesDefault
    private let formData: GetPhoneTopUpFormDataOutput
    private weak var accountSelectorDelegate: AccountSelectorDelegate?
    private weak var internetContactsDelegate: InternetContactsDelegate?
    
    private lazy var phoneTopUpController: PhoneTopUpFormViewController = {
        return dependenciesEngine.resolve(for: PhoneTopUpFormViewController.self)
    }()
    
    // MARK: Lifecycle
    
    public init(dependenciesResolver: DependenciesResolver,
                navigationController: UINavigationController?,
                formData: GetPhoneTopUpFormDataOutput) {
        self.navigationController = navigationController
        self.dependenciesEngine = DependenciesDefault(father: dependenciesResolver)
        self.formData = formData
        self.setUpDependencies()
    }
    
    // MARK: Dependencies
    
    private func setUpDependencies() {
        self.dependenciesEngine.register(for: PhoneTopUpFormCoordinatorProtocol.self) { _ in
            return self
        }
        self.dependenciesEngine.register(for: PhoneTopUpFormPresenterProtocol.self) { [formData] resolver in
            return PhoneTopUpFormPresenter(dependenciesResolver: resolver, accounts: formData.accounts, operators: formData.operators, gsmOperators: formData.gsmOperators)
        }
        self.dependenciesEngine.register(for: PhoneTopUpFormViewController.self) { [weak self] resolver in
            let presenter = resolver.resolve(for: PhoneTopUpFormPresenterProtocol.self)
            let viewController = PhoneTopUpFormViewController(presenter: presenter)
            presenter.view = viewController
            self?.accountSelectorDelegate = presenter
            self?.internetContactsDelegate = presenter
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
    
    public func start() {
        let selectedAccount = formData.accounts.first(where: \.defaultForPayments)
        guard selectedAccount != nil else {
            self.navigationController?.pushViewController(phoneTopUpController, animated: false)
            showAccountSelector(availableAccounts: formData.accounts, selectedAccountNumber: nil, mode: .mustSelectDefaultAccount)
            return
        }
        
        self.navigationController?.pushViewController(phoneTopUpController, animated: true)
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
    
    func showAccountSelector(availableAccounts: [AccountForDebit], selectedAccountNumber: String?, mode: AccountSelectorMode) {
        let accountSelectorCoordinator = AccountSelectorCoordinator(dependenciesResolver: dependenciesEngine,
                                                                    navigationController: navigationController,
                                                                    mode: mode,
                                                                    accounts: availableAccounts,
                                                                    selectedAccountNumber: selectedAccountNumber,
                                                                    accountSelectorDelegate: self)
        accountSelectorCoordinator.start()
    }
    
    func didTouchContactsButton() {
        let internetContactsCoordinator = InternetContactsCoordinator(dependenciesResolver: dependenciesEngine,
                                                                      delegate: self,
                                                                      navigationController: navigationController,
                                                                      contacts: formData.internetContacts)
        internetContactsCoordinator.start()
    }
}

extension PhoneTopUpFormCoordinator: AccountSelectorDelegate {
    func accountSelectorDidSelectAccount(withAccountNumber accountNumber: String) {
        accountSelectorDelegate?.accountSelectorDidSelectAccount(withAccountNumber: accountNumber)
    }
}

extension PhoneTopUpFormCoordinator: InternetContactsDelegate {
    func internetContactsDidSelectContact(_ contact: MobileContact) {
        navigationController?.popViewController(animated: true)
        internetContactsDelegate?.internetContactsDidSelectContact(contact)
    }
}

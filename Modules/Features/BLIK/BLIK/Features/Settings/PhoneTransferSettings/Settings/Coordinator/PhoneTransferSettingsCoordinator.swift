//
//  PhoneTransferSettingsCoordinator.swift
//  BLIK
//
//  Created by Piotr Mielcarzewicz on 27/07/2021.
//



import UI
import PLUI
import Models
import Commons
import SANPLLibrary
import PLCommons

protocol PhoneTransferSettingsCoordinatorProtocol: ModuleCoordinator {
    func showPhoneNumberUnregisterConfirmation(onConfirm: @escaping () -> Void)
    func showPhoneNumberRegistrationForm()
    func showAccountSelector(with accounts: [BlikCustomerAccount])
    func showSmsConfirmationScreen(selectedAccountNumber: String)
    func goBackToBlikSettingsFromSmsScreen()
    func showTransferSettingsAfterPhoneRegistrationFromFormScreen()
    func showTransferSettingsAfterPhoneRegistrationFromSmsScreen()
    func close()
}

final class PhoneTransferSettingsCoordinator: ModuleCoordinator {
    public weak var navigationController: UINavigationController?
    private let dependenciesEngine: DependenciesDefault
    private let wallet: SharedValueBox<GetWalletUseCaseOkOutput.Wallet>
    private let viewModelMapper: PhoneTransferSettingsViewModelMapping
    private let phoneTransferSettingsFactory: PhoneTransferSettingsProducing
    private let unregisterPhoneNumberConfirmationFactory: UnregisterPhoneNumberConfirmationProducing
    private weak var phoneTransferSettingsView: PhoneTransferSettingsView?
    private weak var registrationFormDelegate: PhoneTransferRegistrationFormDelegate?

    public init(
        dependenciesResolver: DependenciesResolver,
        navigationController: UINavigationController?,
        wallet: SharedValueBox<GetWalletUseCaseOkOutput.Wallet>,
        viewModelMapper: PhoneTransferSettingsViewModelMapping = PhoneTransferSettingsViewModelMapper(),
        phoneTransferSettingsFactory: PhoneTransferSettingsProducing,
        unregisterPhoneNumberConfirmationFactory: UnregisterPhoneNumberConfirmationProducing = UnregisterPhoneNumberConfirmationFactory()
    ) {
        self.navigationController = navigationController
        self.dependenciesEngine = DependenciesDefault(father: dependenciesResolver)
        self.wallet = wallet
        self.viewModelMapper = viewModelMapper
        self.phoneTransferSettingsFactory = phoneTransferSettingsFactory
        self.unregisterPhoneNumberConfirmationFactory = unregisterPhoneNumberConfirmationFactory
        setUpDependencies()
    }
    
    public func start() {
        let viewModel = viewModelMapper.map(wallet: wallet.getValue())
        let controller = phoneTransferSettingsFactory.create(
            viewModel: viewModel,
            coordinator: self
        )
        phoneTransferSettingsView = controller
        navigationController?.pushViewController(controller, animated: true)
    }
}

extension PhoneTransferSettingsCoordinator: PhoneTransferSettingsCoordinatorProtocol {
    func showPhoneNumberUnregisterConfirmation(onConfirm: @escaping () -> Void) {
        guard let navigationController = navigationController else { return }
        let confirmationAlert = unregisterPhoneNumberConfirmationFactory.create(
            confirmAction: onConfirm,
            declineAction: {},
            accountToUnregisterNumber: wallet.getValue().sourceAccount.number
        )
        confirmationAlert.showIn(navigationController)
    }
    
    func showPhoneNumberRegistrationForm() {
        let presenter = PhoneTransferRegistrationFormPresenter(dependenciesResolver: dependenciesEngine)
        let viewController = PhoneTransferRegistrationFormViewController(presenter: presenter)
        presenter.view = viewController
        registrationFormDelegate = presenter
        navigationController?.pushViewController(viewController, animated: true)
    }

    func showAccountSelector(with accounts: [BlikCustomerAccount]) {
        let coordinator = AccountSelectorCoordinator(
            dependenciesResolver: dependenciesEngine,
            navigationController: navigationController,
            screenLocationConfiguration: .mobileTransferSettings,
            accounts: accounts,
            accountSelectionHandler: { [weak self] account in
                self?.registrationFormDelegate?.didSelectAccount(account)
            }
        )
        coordinator.start()
    }
    
    func showSmsConfirmationScreen(selectedAccountNumber: String) {
        let presenter = SmsConfirmationPresenter(
            dependenciesResolver: dependenciesEngine,
            coordinator: self,
            registerPhoneNumberUseCase: RegisterPhoneNumberUseCase(
               dependenciesResolver: dependenciesEngine
            ),
            selectedAccountNumber: selectedAccountNumber
        )
        let viewController = SmsConfirmationViewController(presenter: presenter)
        presenter.view = viewController
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func goBackToBlikSettingsFromSmsScreen() {
        navigationController?.popViewController(animated: false)
        navigationController?.popViewController(animated: false)
        navigationController?.popViewController(animated: true)
    }
    
    func showTransferSettingsAfterPhoneRegistrationFromFormScreen() {
        navigationController?.popViewController(animated: true)
        phoneTransferSettingsView?.setViewModel(.registeredPhoneNumber)
    }
    
    func showTransferSettingsAfterPhoneRegistrationFromSmsScreen() {
        navigationController?.popViewController(animated: false)
        navigationController?.popViewController(animated: true)
        phoneTransferSettingsView?.setViewModel(.registeredPhoneNumber)
    }
    
    func close() {
        navigationController?.popViewController(animated: true)
    }
}

private extension PhoneTransferSettingsCoordinator {
    func setUpDependencies() {
        dependenciesEngine.register(for: PhoneTransferSettingsCoordinatorProtocol.self) { _ in
            return self
        }
        
        dependenciesEngine.register(for: BlikCustomerAccountMapping.self) { _ in
            return BlikCustomerAccountMapper()
        }
        
        dependenciesEngine.register(for: PhoneTransferRegistrationFormViewModelMapping.self) { _ in
            return PhoneTransferRegistrationFormViewModelMapper(amountFormatter: .PLAmountNumberFormatter)
        }
        
        dependenciesEngine.register(for: RegisterPhoneNumberUseCaseProtocol.self) { resolver in
            return RegisterPhoneNumberUseCase(dependenciesResolver: resolver)
        }
        
        dependenciesEngine.register(for: LoadCustomerAccountsUseCaseProtocol.self) { resolver in
            return LoadCustomerAccountsUseCase(dependenciesResolver: resolver)
        }
    }
}

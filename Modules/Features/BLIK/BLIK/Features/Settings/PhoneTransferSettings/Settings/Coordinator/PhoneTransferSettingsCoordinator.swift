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
    func showPhoneNumberUpdateForm()
    func showAccountSelector()
    func showSmsConfirmationScreen(selectedAccountNumber: String)
    func goBackToBlikSettingsFromSmsScreen()
    func showTransferSettingsAfterPhoneRegistrationFromFormScreen()
    func showTransferSettingsAfterPhoneRegistrationFromSmsScreen()
    func close()
}

final class PhoneTransferSettingsCoordinator: ModuleCoordinator {
    public weak var navigationController: UINavigationController?
    private let dependenciesEngine: DependenciesDefault
    private let wallet: GetWalletUseCaseOkOutput.Wallet
    private let viewModelMapper: PhoneTransferSettingsViewModelMapping
    private let phoneTransferSettingsFactory: PhoneTransferSettingsProducing
    private let unregisterPhoneNumberConfirmationFactory: UnregisterPhoneNumberConfirmationProducing
    private weak var phoneTransferSettingsView: PhoneTransferSettingsView?
    private weak var registrationFormDelegate: PhoneTransferRegistrationFormDelegate?

    public init(
        dependenciesResolver: DependenciesResolver,
        navigationController: UINavigationController?,
        wallet: GetWalletUseCaseOkOutput.Wallet,
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
    }
    
    public func start() {
        let viewModel = viewModelMapper.map(wallet: wallet)
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
            accountToUnregisterNumber: wallet.sourceAccount.number
        )
        confirmationAlert.showIn(navigationController)
    }
    
    func showPhoneNumberRegistrationForm() {
        let viewModelMapper = PhoneTransferRegistrationFormViewModelMapper(amountFormatter: .PLAmountNumberFormatter)
        let viewModel = viewModelMapper.map(wallet.sourceAccount)
        let presenter = PhoneTransferRegistrationFormPresenter(
            dependenciesResolver: dependenciesEngine,
            coordinator: self,
            initialViewModel: viewModel,
            viewModelMapper: viewModelMapper,
            registerPhoneNumberUseCase: RegisterPhoneNumberUseCase(
                managersProvider: dependenciesEngine.resolve(for: PLManagersProviderProtocol.self)
            )
        )
        let viewController = PhoneTransferRegistrationFormViewController(presenter: presenter)
        presenter.view = viewController
        registrationFormDelegate = presenter
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func showPhoneNumberUpdateForm() {
        // TODO:- Handle action
    }
    
    func showAccountSelector() {
        let coordinator = AccountSelectorCoordinator(
            dependenciesResolver: dependenciesEngine,
            navigationController: navigationController,
            screenLocationConfiguration: .mobileTransferSettings,
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
                managersProvider: dependenciesEngine.resolve(for: PLManagersProviderProtocol.self)
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

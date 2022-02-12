import CoreFoundationLib
import PLCommons

protocol PhoneTransferRegistrationFormPresenterProtocol {
    func viewDidLoad()
    func didPressRegister()
    func didPressChangeAccount()
    func didPressClose()
    func hasUserOneAccount() -> Bool
}

protocol PhoneTransferRegistrationFormDelegate: AnyObject {
    func didSelectAccount(_ account: BlikCustomerAccount)
}

final class PhoneTransferRegistrationFormPresenter: PhoneTransferRegistrationFormDelegate {
    weak var view: PhoneTransferRegistrationFormViewController?
    
    private let dependenciesResolver: DependenciesResolver
    private var coordinator: PhoneTransferSettingsCoordinatorProtocol {
        dependenciesResolver.resolve()
    }
    private var viewModelMapper: PhoneTransferRegistrationFormViewModelMapping {
        dependenciesResolver.resolve()
    }
    private var loadAccountsUseCase: LoadCustomerAccountsUseCaseProtocol {
        dependenciesResolver.resolve()
    }
    private var registerPhoneNumberUseCase: RegisterPhoneNumberUseCaseProtocol {
        dependenciesResolver.resolve()
    }
    private var loadWalletUseCase: GetWalletsActiveProtocol {
        dependenciesResolver.resolve()
    }
    private var useCaseHandler: UseCaseHandler {
        return self.dependenciesResolver.resolve(for: UseCaseHandler.self)
    }
    
    private let wallet: SharedValueBox<GetWalletUseCaseOkOutput.Wallet>
    private var fetchedAccounts: [BlikCustomerAccount] = []
    private var selectedAccountNumber: String = ""

    
    init(
        dependenciesResolver: DependenciesResolver,
        wallet: SharedValueBox<GetWalletUseCaseOkOutput.Wallet>
    ) {
        self.dependenciesResolver = dependenciesResolver
        self.wallet = wallet
    }
}

extension PhoneTransferRegistrationFormPresenter: PhoneTransferRegistrationFormPresenterProtocol {
    func viewDidLoad() {
        view?.showLoader()
        Scenario(useCase: loadAccountsUseCase)
            .execute(on: useCaseHandler)
            .onSuccess { [weak self] output in
                self?.view?.hideLoader(completion: {
                    self?.handleFetchedAccounts(output.accounts)
                })
            }
            .onError { [weak self] _ in
                self?.view?.hideLoader(completion: {
                    self?.view?.showServiceInaccessibleMessage(onConfirm: {
                        self?.coordinator.close()
                    })
                })
            }
    }
    
    func didPressRegister() {
        let request = RegisterPhoneNumberRequest(
            accountNo: selectedAccountNumber,
            authCode: nil
        )
        view?.showLoader()
        let input = RegisterPhoneNumberUseCaseInput(
            registerPhoneNumberRequest: request
        )
        Scenario(useCase: registerPhoneNumberUseCase, input: input)
            .execute(on: useCaseHandler)
            .onSuccess { [weak self] output in
                self?.handleRegisterResponse(output.registerPhoneNumberResponse)
            }
            .onError { [weak self] _ in
                guard let strongSelf = self else { return }
                strongSelf.view?.hideLoader(completion: {
                    strongSelf.view?.showServiceInaccessibleMessage(onConfirm: nil)
                })
            }
    }
    
    func didPressChangeAccount() {
        coordinator.showAccountSelector(
            with: fetchedAccounts,
            selectedAccountNumber: selectedAccountNumber
        )
    }
            
    func didPressClose() {
        coordinator.close()
    }
    
    func didSelectAccount(_ account: BlikCustomerAccount) {
        let viewModel = viewModelMapper.map(account)
        selectedAccountNumber = account.number
        view?.setViewModel(viewModel)
    }
    
    func hasUserOneAccount() -> Bool {
        return fetchedAccounts.count <= 1
    }
}

private extension PhoneTransferRegistrationFormPresenter {
    func handleRegisterResponse(_ response: RegisterPhoneNumberResponse) {
        switch response {
        case .successfulyRegisteredPhoneNumber:
            fetchWalletAndGoBackToSettings()
        case .smsAuthorizationCodeSent:
            view?.hideLoader(completion: { [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.coordinator.showSmsConfirmationScreen(
                    selectedAccountNumber: strongSelf.selectedAccountNumber
                )
            })
            
        }
    }
    
    func handleFetchedAccounts(_ accounts: [BlikCustomerAccount]) {
        guard let selectedAccount = accounts.first(where: { $0.defaultForP2P == true }) else {
            view?.showServiceInaccessibleMessage(onConfirm: { [weak self] in
                self?.coordinator.close()
            })
            return
        }
        fetchedAccounts = accounts
        selectedAccountNumber = selectedAccount.number
        let viewModel = viewModelMapper.map(selectedAccount)
        view?.setViewModel(viewModel)
    }
    
    private func fetchWalletAndGoBackToSettings() {
        Scenario(useCase: loadWalletUseCase)
            .execute(on: useCaseHandler)
            .onSuccess { [weak self] response in
                self?.view?.hideLoader(completion: {
                    self?.handleUpdatedWallet(with: response)
                })
            }
            .onError { [weak self] _ in
                self?.view?.hideLoader(completion: {
                    self?.view?.showServiceInaccessibleMessage(onConfirm: { [weak self] in
                        self?.coordinator.goBackToGlobalPosition()
                    })
                })
            }
    }
    
    private func handleUpdatedWallet(with response: GetWalletUseCaseOkOutput) {
        switch response.serviceStatus {
        case let .available(wallet):
            self.wallet.setValue(wallet)
            coordinator.showTransferSettingsAfterPhoneRegistrationFromFormScreen()
        case .unavailable:
            view?.showServiceInaccessibleMessage(onConfirm: { [weak self] in
                self?.coordinator.goBackToGlobalPosition()
            })
        }
    }
}

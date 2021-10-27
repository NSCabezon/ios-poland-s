import Commons
import DomainCommon
import PLCommons

protocol PhoneTransferRegistrationFormPresenterProtocol {
    func viewDidLoad()
    func didPressRegister()
    func didPressChangeAccount()
    func didPressClose()
}

protocol PhoneTransferRegistrationFormDelegate: AnyObject {
    func didSelectAccount(_ account: BlikCustomerAccount)
}

final class PhoneTransferRegistrationFormPresenter: PhoneTransferRegistrationFormDelegate {
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
    private var useCaseHandler: UseCaseHandler {
        return self.dependenciesResolver.resolve(for: UseCaseHandler.self)
    }
    
    private var fetchedAccounts: [BlikCustomerAccount] = []
    private var selectedAccountNumber: String = ""

    weak var view: PhoneTransferRegistrationFormViewController?
    
    init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
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
                guard let strongSelf = self else { return }
                strongSelf.view?.hideLoader(completion: {
                    strongSelf.handleRegisterResponse(
                        output.registerPhoneNumberResponse
                    )
                })
            }
            .onError { [weak self] _ in
                guard let strongSelf = self else { return }
                strongSelf.view?.hideLoader(completion: {
                    strongSelf.view?.showServiceInaccessibleMessage(onConfirm: nil)
                })
            }
    }
    
    func didPressChangeAccount() {
        coordinator.showAccountSelector(with: fetchedAccounts)
    }
            
    func didPressClose() {
        coordinator.close()
    }
    
    func didSelectAccount(_ account: BlikCustomerAccount) {
        let viewModel = viewModelMapper.map(account)
        selectedAccountNumber = account.number
        view?.setViewModel(viewModel)
    }
}

private extension PhoneTransferRegistrationFormPresenter {
    func handleRegisterResponse(_ response: RegisterPhoneNumberResponse) {
        switch response {
        case .successfulyRegisteredPhoneNumber:
            coordinator.showTransferSettingsAfterPhoneRegistrationFromFormScreen()
        case .smsAuthorizationCodeSent:
            coordinator.showSmsConfirmationScreen(selectedAccountNumber: selectedAccountNumber)
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
        let viewModel = viewModelMapper.map(selectedAccount)
        view?.setViewModel(viewModel)
    }
}

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
    func didSelectAccount(_ account: AccountForDebit)
}

final class PhoneTransferRegistrationFormPresenter: PhoneTransferRegistrationFormPresenterProtocol, PhoneTransferRegistrationFormDelegate {
    private let dependenciesResolver: DependenciesResolver
    private let coordinator: PhoneTransferSettingsCoordinatorProtocol
    private let initialViewModel: PhoneTransferRegistrationFormViewModel
    private let viewModelMapper: PhoneTransferRegistrationFormViewModelMapping
    private let registerPhoneNumberUseCase: RegisterPhoneNumberUseCaseProtocol
    private var selectedAccountNumber: String
    private var useCaseHandler: UseCaseHandler {
        return self.dependenciesResolver.resolve(for: UseCaseHandler.self)
    }
    weak var view: PhoneTransferRegistrationFormViewController?
    
    init(
        dependenciesResolver: DependenciesResolver,
        coordinator: PhoneTransferSettingsCoordinatorProtocol,
        initialViewModel: PhoneTransferRegistrationFormViewModel,
        viewModelMapper: PhoneTransferRegistrationFormViewModelMapping,
        registerPhoneNumberUseCase: RegisterPhoneNumberUseCaseProtocol
    ) {
        self.dependenciesResolver = dependenciesResolver
        self.coordinator = coordinator
        self.initialViewModel = initialViewModel
        self.viewModelMapper = viewModelMapper
        self.registerPhoneNumberUseCase = registerPhoneNumberUseCase
        self.selectedAccountNumber = initialViewModel.accountViewModel.accountNumber
    }
    
    func viewDidLoad() {
        view?.setViewModel(initialViewModel)
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
            .onError { [weak self] error in
                guard let strongSelf = self else { return }
                strongSelf.view?.hideLoader(completion: {
                    strongSelf.view?.showServiceInaccessibleMessage(onConfirm: nil)
                })
            }
    }
    
    func didPressChangeAccount() {
        coordinator.showAccountSelector()
    }
            
    func didPressClose() {
        coordinator.close()
    }
    
    func didSelectAccount(_ account: AccountForDebit) {
        let viewModel = viewModelMapper.map(account)
        selectedAccountNumber = account.number
        view?.setViewModel(viewModel)
    }
    
    private func handleRegisterResponse(_ response: RegisterPhoneNumberResponse) {
        switch response {
        case .successfulyRegisteredPhoneNumber:
            coordinator.showTransferSettingsAfterPhoneRegistrationFromFormScreen()
        case .smsAuthorizationCodeSent:
            coordinator.showSmsConfirmationScreen(selectedAccountNumber: selectedAccountNumber)
        }
    }
}

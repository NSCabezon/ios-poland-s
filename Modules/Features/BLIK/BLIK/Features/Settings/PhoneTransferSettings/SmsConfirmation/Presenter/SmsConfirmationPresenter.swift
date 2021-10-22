import Commons
import DomainCommon
import PLUI

protocol SmsConfirmationPresenterProtocol {
    func didPressSubmit(withCode authCode: String)
    func didPressClose()
}

final class SmsConfirmationPresenter: SmsConfirmationPresenterProtocol {
    private let dependenciesResolver: DependenciesResolver
    private let coordinator: PhoneTransferSettingsCoordinatorProtocol
    private let registerPhoneNumberUseCase: RegisterPhoneNumberUseCaseProtocol
    private let selectedAccountNumber: String
    private var useCaseHandler: UseCaseHandler {
        return self.dependenciesResolver.resolve(for: UseCaseHandler.self)
    }
    public weak var view: SmsConfirmationView?
    
    init(
        dependenciesResolver: DependenciesResolver,
        coordinator: PhoneTransferSettingsCoordinatorProtocol,
        registerPhoneNumberUseCase: RegisterPhoneNumberUseCaseProtocol,
        selectedAccountNumber: String
    ) {
        self.dependenciesResolver = dependenciesResolver
        self.coordinator = coordinator
        self.registerPhoneNumberUseCase = registerPhoneNumberUseCase
        self.selectedAccountNumber = selectedAccountNumber
    }

    func didPressSubmit(withCode authCode: String) {
        let request = RegisterPhoneNumberRequest(
            accountNo: selectedAccountNumber,
            authCode: authCode
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
                    strongSelf.view?.showServiceInaccessibleMessage(onConfirm: { [weak self] in
                        self?.coordinator.goBackToBlikSettingsFromSmsScreen()
                    })
                })
            }
    }
    
    func didPressClose() {
        coordinator.close()
    }
    
    private func handleRegisterResponse(_ response: RegisterPhoneNumberResponse) {
        switch response {
        case .successfulyRegisteredPhoneNumber:
            coordinator.showTransferSettingsAfterPhoneRegistrationFromSmsScreen()
        case .smsAuthorizationCodeSent:
            view?.showServiceInaccessibleMessage(onConfirm: { [weak self] in
                self?.coordinator.goBackToBlikSettingsFromSmsScreen()
            })
        }
    }
}

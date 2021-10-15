import Foundation
import Commons
import PLUI

protocol SmsConfirmationPresenterProtocol {
    func didPressSubmit(withCode authCode: String)
    func didPressClose()
}

final class SmsConfirmationPresenter: SmsConfirmationPresenterProtocol {
    private let coordinator: PhoneTransferSettingsCoordinatorProtocol
    private let registerPhoneNumberUseCase: RegisterPhoneNumberUseCaseProtocol
    private let selectedAccountNumber: String
    
    public weak var view: SmsConfirmationView?
    
    init(
        coordinator: PhoneTransferSettingsCoordinatorProtocol,
        registerPhoneNumberUseCase: RegisterPhoneNumberUseCaseProtocol,
        selectedAccountNumber: String
    ) {
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
        Scenario(useCase: registerPhoneNumberUseCase, input: request)
            .execute(on: DispatchQueue.global())
            .onSuccess { [weak self] response in
                guard let strongSelf = self else { return }
                strongSelf.view?.hideLoader(completion: {
                    strongSelf.handleRegisterResponse(response)
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

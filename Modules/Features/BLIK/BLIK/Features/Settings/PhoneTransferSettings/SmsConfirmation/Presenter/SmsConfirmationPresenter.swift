import CoreFoundationLib
import CoreFoundationLib
import PLUI

protocol SmsConfirmationPresenterProtocol {
    func didPressSubmit(withCode authCode: String)
    func didPressClose()
}

final class SmsConfirmationPresenter {
    private let dependenciesResolver: DependenciesResolver
    private var coordinator: PhoneTransferSettingsCoordinatorProtocol {
        dependenciesResolver.resolve()
    }
    private var registerPhoneNumberUseCase: RegisterPhoneNumberUseCaseProtocol {
        dependenciesResolver.resolve()
    }
    private var loadWalletUseCase: GetWalletsActiveProtocol {
        dependenciesResolver.resolve()
    }
    private var useCaseHandler: UseCaseHandler {
        dependenciesResolver.resolve()
    }

    private let selectedAccountNumber: String
    private let wallet: SharedValueBox<GetWalletUseCaseOkOutput.Wallet>
    public weak var view: SmsConfirmationView?
    
    init(
        dependenciesResolver: DependenciesResolver,
        selectedAccountNumber: String,
        wallet: SharedValueBox<GetWalletUseCaseOkOutput.Wallet>
    ) {
        self.dependenciesResolver = dependenciesResolver
        self.selectedAccountNumber = selectedAccountNumber
        self.wallet = wallet
    }
}

extension SmsConfirmationPresenter: SmsConfirmationPresenterProtocol {
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
                    strongSelf.showError(onConfirm: { [weak self] in
                        self?.coordinator.goBackToBlikSettingsFromSmsScreen()
                    })
                })
            }
    }
    
    func didPressClose() {
        coordinator.close()
    }
    
    private func showError(onConfirm: (() -> Void)?) {
        view?.showErrorMessage(title: "",
                               message: localized("pl_blik_text_wrongSmsCode"),
                               actionButtonTitle: localized("generic_link_ok"),
                               closeButton: .none,
                               onConfirm: onConfirm)
    }
}

private extension SmsConfirmationPresenter {
    func handleRegisterResponse(_ response: RegisterPhoneNumberResponse) {
        switch response {
        case .successfulyRegisteredPhoneNumber:
            fetchWalletAndGoBackToSettings()
        case .smsAuthorizationCodeSent:
            view?.hideLoader(completion: { [weak self] in
                self?.view?.showServiceInaccessibleMessage(onConfirm: {
                    self?.coordinator.goBackToBlikSettingsFromSmsScreen()
                })
            })
        }
    }
    
    func fetchWalletAndGoBackToSettings() {
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
    
    func handleUpdatedWallet(with response: GetWalletUseCaseOkOutput) {
        switch response.serviceStatus {
        case let .available(wallet):
            self.wallet.setValue(wallet)
            coordinator.showTransferSettingsAfterPhoneRegistrationFromSmsScreen()
        case .unavailable:
            view?.showServiceInaccessibleMessage(onConfirm: { [weak self] in
                self?.coordinator.goBackToGlobalPosition()
            })
        }
    }
}

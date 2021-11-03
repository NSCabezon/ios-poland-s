//
//  PhoneTransferSettingsPresenter.swift
//  BLIK
//
//  Created by Piotr Mielcarzewicz on 22/07/2021.
//

import Commons
import DomainCommon
import UI
import PLUI

protocol PhoneTransferSettingsPresenterProtocol {
    func didPressRemovePhoneNumber()
    func didPressRegisterPhoneNumber()
    func didPressUpdatePhoneNumber()
    func didPressUpdateAccountNumber()
    func didPressClose()
}

final class PhoneTransferSettingsPresenter {
    private let dependenciesResolver: DependenciesResolver
    
    private var coordinator: PhoneTransferSettingsCoordinatorProtocol {
        dependenciesResolver.resolve()
    }
    
    private var unregisterPhoneNumberUseCase: UnregisterPhoneNumberUseCaseProtocol {
        dependenciesResolver.resolve()
    }
    
    private var getWalletUseCase: GetWalletsActiveProtocol {
        dependenciesResolver.resolve()
    }
    
    private var useCaseHandler: UseCaseHandler {
        return self.dependenciesResolver.resolve(for: UseCaseHandler.self)
    }
    
    private let wallet: SharedValueBox<GetWalletUseCaseOkOutput.Wallet>
    weak var view: PhoneTransferSettingsView?
    
    init(
        dependenciesResolver: DependenciesResolver,
        wallet: SharedValueBox<GetWalletUseCaseOkOutput.Wallet>
    ) {
        self.dependenciesResolver = dependenciesResolver
        self.wallet = wallet
    }
}

extension PhoneTransferSettingsPresenter: PhoneTransferSettingsPresenterProtocol {
    func didPressRemovePhoneNumber() {
        coordinator.showPhoneNumberUnregisterConfirmation(onConfirm: { [weak self] in
            self?.unregisterPhoneNumber()
        })
    }
    
    func didPressRegisterPhoneNumber() {
        coordinator.showPhoneNumberRegistrationForm()
    }
    
    func didPressUpdatePhoneNumber() {
        coordinator.showPhoneNumberRegistrationForm()
    }
    
    func didPressUpdateAccountNumber() {
        coordinator.showPhoneNumberRegistrationForm()
    }
    
    func didPressClose() {
        coordinator.close()
    }
}

private extension PhoneTransferSettingsPresenter {
    func unregisterPhoneNumber() {
        view?.showLoader()
        Scenario(useCase: unregisterPhoneNumberUseCase)
            .execute(on: useCaseHandler)
            .onSuccess { [weak self] in
                self?.updateWalletAndViewState()
            }
            .onError { [weak self] error in
                self?.view?.hideLoader(completion: {
                    self?.view?.showServiceInaccessibleMessage(onConfirm: nil)
                })
            }
    }
    
    func updateWalletAndViewState() {
        view?.showLoader()
        Scenario(useCase: getWalletUseCase)
            .execute(on: useCaseHandler)
            .onSuccess { [weak self] response in
                self?.view?.hideLoader(completion: {
                    self?.view?.setViewModel(.unregisteredPhoneNumber)
                    self?.coordinator.showUnregisteredNumberSuccessAlert()
                    self?.handleFetchedWalletResponse(response)
                })
            }
            .onError { [weak self] error in
                self?.view?.hideLoader(completion: {
                    self?.view?.showServiceInaccessibleMessage(onConfirm: {
                        self?.coordinator.goBackToGlobalPosition()
                    })
                })
            }
    }
    
    func handleFetchedWalletResponse(_ response: GetWalletUseCaseOkOutput) {
        switch response.serviceStatus {
        case let .available(wallet):
            self.wallet.setValue(wallet)
        case .unavailable:
            view?.showServiceInaccessibleMessage(onConfirm: { [weak self] in
                self?.coordinator.goBackToGlobalPosition()
            })
        }
    }
}

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

final class PhoneTransferSettingsPresenter: PhoneTransferSettingsPresenterProtocol {
    private let dependenciesResolver: DependenciesResolver
    private let coordinator: PhoneTransferSettingsCoordinatorProtocol
    private let unregisterPhoneNumberUseCase: UnregisterPhoneNumberUseCaseProtocol
    private var useCaseHandler: UseCaseHandler {
        return self.dependenciesResolver.resolve(for: UseCaseHandler.self)
    }
    weak var view: PhoneTransferSettingsView?
    
    init(
        dependenciesResolver: DependenciesResolver,
        coordinator: PhoneTransferSettingsCoordinatorProtocol,
        unregisterPhoneNumberUseCase: UnregisterPhoneNumberUseCaseProtocol
    ) {
        self.dependenciesResolver = dependenciesResolver
        self.coordinator = coordinator
        self.unregisterPhoneNumberUseCase = unregisterPhoneNumberUseCase
    }
    
    func didPressRemovePhoneNumber() {
        coordinator.showPhoneNumberUnregisterConfirmation(onConfirm: { [weak self] in
            self?.unregisterPhoneNumber()
        })
    }
    
    func didPressRegisterPhoneNumber() {
        coordinator.showPhoneNumberRegistrationForm()
    }
    
    func didPressUpdatePhoneNumber() {
        coordinator.showPhoneNumberUpdateForm()
    }
    
    func didPressUpdateAccountNumber() {
        coordinator.showAccountSelector()
    }
    
    func didPressClose() {
        coordinator.close()
    }
    
    private func unregisterPhoneNumber() {
        view?.showLoader()
        Scenario(useCase: unregisterPhoneNumberUseCase)
            .execute(on: useCaseHandler)
            .onSuccess { [weak self] in
                self?.view?.hideLoader(completion: {
                    self?.showUnregisteredPhoneNumberState()
                })
            }
            .onError { [weak self] error in
                self?.view?.hideLoader(completion: {
                    self?.view?.showServiceInaccessibleMessage(onConfirm: nil)
                })
            }
    }
    
    private func showUnregisteredPhoneNumberState() {
        view?.setViewModel(.unregisteredPhoneNumber)
        TopAlertController.setup(TopAlertView.self).showAlert(
            localized("#Informacja\nNumer został wyrejestrowany z bazy powiązań BLIK"),
            alertType: .info,
            position: .top
        )
    }
}

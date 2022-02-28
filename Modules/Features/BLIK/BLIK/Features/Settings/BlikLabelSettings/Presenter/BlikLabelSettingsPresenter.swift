//
//  BlikLabelSettingsPresenter.swift
//  BLIK
//
//  Created by 185167 on 23/02/2022.
//

import CoreFoundationLib
import PLCommons
import PLUI

protocol BlikLabelSettingsPresenterProtocol {
    func viewDidLoad()
    func didUpdateForm(with newBlikLabel: String)
    func didPressSave(with newBlikLabel: String)
    func didPressBack(with newBlikLabel: String)
    func didPressClose(with newBlikLabel: String)
}

final class BlikLabelSettingsPresenter {
    private let wallet: SharedValueBox<GetWalletUseCaseOkOutput.Wallet>
    private var initialBlikLabel: String
    private let dependenciesResolver: DependenciesResolver
    weak var view: BlikLabelSettingsView?
    
    init(
        wallet: SharedValueBox<GetWalletUseCaseOkOutput.Wallet>,
        dependenciesResolver: DependenciesResolver
    ) {
        self.wallet = wallet
        self.initialBlikLabel = wallet.getValue().alias.label
        self.dependenciesResolver = dependenciesResolver
    }
}

extension BlikLabelSettingsPresenter: BlikLabelSettingsPresenterProtocol {
    func viewDidLoad() {
        view?.setLabel(initialBlikLabel)
    }
    
    func didPressSave(with newBlikLabel: String) {
        let customerLabelInput = SaveBlikCustomerLabelInput(
            blikCustomerLabel: newBlikLabel
        )
            
        view?.showLoader()
        Scenario(useCase: saveBlikCustomerLabelUseCase, input: customerLabelInput)
            .execute(on: useCaseHandler)
            .onSuccess { [weak self] _ in
                self?.tryToUpdateWalletAndGoBack()
            }
            .onError { [weak self] error in
                self?.view?.hideLoader(completion: {
                    self?.view?.showServiceInaccessibleMessage(onConfirm: nil)
                })
            }
    }
    
    func didPressBack(with newBlikLabel: String) {
        guard let view = view else { return }
        let blikLabelDidNotChange = initialBlikLabel == newBlikLabel
        
        guard blikLabelDidNotChange else {
            confirmationDialogFactory.createEndProcessDialog(
                confirmAction: { [weak self] in self?.coordinator.back() },
                declineAction: {}
            ).showIn(view.associatedDialogView)
            return
        }
        
        coordinator.back()
    }

    func didPressClose(with newBlikLabel: String) {
        guard let view = view else { return }
        let blikLabelDidNotChange = initialBlikLabel == newBlikLabel
        
        guard blikLabelDidNotChange else {
            confirmationDialogFactory.createEndProcessDialog(
                confirmAction: { [weak self] in self?.coordinator.close() },
                declineAction: {}
            ).showIn(view.associatedDialogView)
            return
        }
        
        coordinator.close()
    }
    
    func didUpdateForm(with newBlikLabel: String) {
        let isLabelValid = validateCustomerLabel(newBlikLabel)
        let blikLabelDidChange = newBlikLabel != initialBlikLabel
        let isSaveButonEnabled = isLabelValid && blikLabelDidChange
        view?.setSaveButtonState(isEnabled: isSaveButonEnabled)
    }
    
    private func validateCustomerLabel(_ label: String) -> Bool {
        switch labelValidator.validate(label) {
        case .valid:
            view?.setLabelValidationError(nil)
            return true
        case let .invalid(reason):
            view?.setLabelValidationError(reason.localizedString)
            return false
        }
    }
    
    private func tryToUpdateWalletAndGoBack() {
        Scenario(useCase: loadWalletUseCase)
            .execute(on: useCaseHandler)
            .onSuccess { [weak self] response in
                self?.view?.hideLoader(completion: {
                    switch response.serviceStatus {
                    case let .available(newWallet):
                        self?.wallet.setValue(newWallet)
                        self?.coordinator.notifyAboutLabelUpdateAndGoBack(
                            newBlikLabel: newWallet.alias.label
                        )
                    case .unavailable:
                        self?.view?.showServiceInaccessibleMessage(onConfirm: { [weak self] in
                            self?.coordinator.close()
                        })
                    }
                })
            }
            .onError { [weak self] error in
                self?.view?.hideLoader(completion: {
                    self?.view?.showServiceInaccessibleMessage(onConfirm: { [weak self] in
                        self?.coordinator.close()
                    })
                })
            }
    }
}

extension BlikLabelSettingsPresenter {
    var coordinator: BlikLabelSettingsCoordinatorProtocol {
        dependenciesResolver.resolve()
    }
    
    var confirmationDialogFactory: ConfirmationDialogProducing {
        dependenciesResolver.resolve()
    }
    
    var labelValidator: BlikCustomerLabelValidating {
        dependenciesResolver.resolve()
    }
    
    var saveBlikCustomerLabelUseCase: SaveBlikCustomerLabelUseCaseProtocol {
        dependenciesResolver.resolve()
    }
    
    var loadWalletUseCase: GetWalletsActiveUseCase {
        dependenciesResolver.resolve()
    }
    
    var useCaseHandler: UseCaseHandler {
        dependenciesResolver.resolve()
    }
}

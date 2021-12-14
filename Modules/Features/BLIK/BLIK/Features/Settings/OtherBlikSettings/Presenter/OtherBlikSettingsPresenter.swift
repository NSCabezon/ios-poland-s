//
//  OtherBlikSettingsPresenter.swift
//  BLIK
//
//  Created by 186491 on 06/08/2021.
//

import UI
import Commons
import CoreFoundationLib
import PLCommons
import PLUI

protocol OtherBlikSettingsPresenterProtocol {
    func viewDidLoad()
    func didPressSave(with newViewModel: OtherBlikSettingsViewModel)
    func didPressClose(with newViewModel: OtherBlikSettingsViewModel)
    func didUpdateForm(with newViewModel: OtherBlikSettingsViewModel)
}

final class OtherBlikSettingsPresenter {
    private let wallet: SharedValueBox<GetWalletUseCaseOkOutput.Wallet>
    private var viewModel: OtherBlikSettingsViewModel
    private let dependenciesResolver: DependenciesResolver

    weak var view: OtherBlikSettingsViewController?
    
    private var coordinator: OtherBlikSettingsCoordinatorProtocol {
        dependenciesResolver.resolve()
    }
    
    private var confirmationDialogFactory: ConfirmationDialogProducing {
        dependenciesResolver.resolve()
    }
    
    private var labelValidator: BlikCustomerLabelValidating {
        dependenciesResolver.resolve()
    }
    
    private var saveBlikCustomerLabelUseCase: SaveBlikCustomerLabelUseCaseProtocol {
        dependenciesResolver.resolve()
    }
    
    private var loadWalletUseCase: GetWalletsActiveUseCase {
        dependenciesResolver.resolve()
    }
    
    private var useCaseHandler: UseCaseHandler {
        return self.dependenciesResolver.resolve(for: UseCaseHandler.self)
    }
    
    init(
        wallet: SharedValueBox<GetWalletUseCaseOkOutput.Wallet>,
        dependenciesResolver: DependenciesResolver
    ) {
        self.wallet = wallet
        let currentWallet = wallet.getValue()
        self.viewModel = OtherBlikSettingsViewModel(
            blikCustomerLabel: currentWallet.alias.label,
            isTransactionVisible: currentWallet.noPinTrnVisible
        )
        self.dependenciesResolver = dependenciesResolver
    }
}

extension OtherBlikSettingsPresenter: OtherBlikSettingsPresenterProtocol {
    func viewDidLoad() {
        view?.setViewModel(viewModel: viewModel)
    }
    
    func didPressSave(with newViewModel: OtherBlikSettingsViewModel) {
        view?.showLoader()
        let input = SaveBlikCustomerLabelInput(chequePin: newViewModel.blikCustomerLabel)
        Scenario(useCase: saveBlikCustomerLabelUseCase, input: input)
            .execute(on: useCaseHandler)
            .onSuccess { [weak self] in
                self?.tryToUpdateWallet()
            }
            .onError { [weak self] error in
                self?.view?.hideLoader(completion: {
                    self?.view?.showServiceInaccessibleMessage(onConfirm: nil)
                })
            }

    }

    func didPressClose(with newViewModel: OtherBlikSettingsViewModel) {
        guard let view = view else { return }
        
        let viewModelDidNotChange = viewModel == newViewModel
        guard viewModelDidNotChange else {
            confirmationDialogFactory.createEndProcessDialog {[weak self] in
                self?.coordinator.close()
            } declineAction: {
            }.showIn(view)
            return
        }
        
        coordinator.close()
    }
    
    func didUpdateForm(with newViewModel: OtherBlikSettingsViewModel) {
        let isLabelValid = validateCustomerLabel(newViewModel.blikCustomerLabel)
        let viewModelDidChange = newViewModel != viewModel
        let isSaveButonEnabled = isLabelValid && viewModelDidChange
        view?.setIsSaveButtonEnabled(isSaveButonEnabled)
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
    
    private func tryToUpdateWallet() {
        Scenario(useCase: loadWalletUseCase)
            .execute(on: useCaseHandler)
            .onSuccess { [weak self] response in
                self?.view?.hideLoader(completion: {
                    self?.handleUpdatedWallet(with: response)
                })
            }
            .onError { [weak self] error in
                self?.view?.hideLoader(completion: {
                    self?.view?.showServiceInaccessibleMessage(onConfirm: nil)
                })
            }
    }
    
    private func handleUpdatedWallet(with response: GetWalletUseCaseOkOutput) {
        switch response.serviceStatus {
        case let .available(newWallet):
            self.wallet.setValue(newWallet)
            self.viewModel = OtherBlikSettingsViewModel(
                blikCustomerLabel: newWallet.alias.label,
                isTransactionVisible: newWallet.noPinTrnVisible
            )
            view?.setIsSaveButtonEnabled(false)
            coordinator.showSaveSettingsSuccessAlert()
        case .unavailable:
            view?.showServiceInaccessibleMessage(onConfirm: { [weak self] in
                self?.coordinator.goBackToRoot()
            })
        }
    }
}

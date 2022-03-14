//
//  OtherBlikSettingsPresenter.swift
//  BLIK
//
//  Created by 186491 on 06/08/2021.
//

import UI
import CoreFoundationLib
import PLCommons
import PLUI

protocol OtherBlikSettingsPresenterProtocol {
    func viewDidLoad()
    func didToggleTransactionVisibilitySwitch(isOn: Bool)
    func didPressBlikLabelEdit()
    func didPressBack()
}

final class OtherBlikSettingsPresenter {
    private let wallet: SharedValueBox<GetWalletUseCaseOkOutput.Wallet>
    private var viewModel: OtherBlikSettingsViewModel
    private let dependenciesResolver: DependenciesResolver
    weak var view: OtherBlikSettingsViewProtocol?
    
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
    
    func didToggleTransactionVisibilitySwitch(isOn shouldTransactionDataBeVisible: Bool) {
        let input = SaveBlikTransactionVisibilityInput(
            isBlikTransactionDataVisibleBeforeSignIn: shouldTransactionDataBeVisible
        )
        
        view?.showLoader()
        Scenario(useCase: saveTransactionVisibilityUseCase, input: input)
        .execute(on: useCaseHandler)
        .onSuccess { [weak self] _ in
            self?.tryToUpdateWalletAndShowSuccessAlert()
        }
        .onError { [weak self] error in
            self?.view?.hideLoader(completion: {
                guard let strongSelf = self else { return }
                strongSelf.coordinator.showErrorAlert()
                strongSelf.view?.setViewModel(viewModel: strongSelf.viewModel)
            })
        }
    }
    
    func didPressBlikLabelEdit() {
        coordinator.showBlikLabelSettings()
    }
    
    func didPressBack() {
        coordinator.back()
    }
}

extension OtherBlikSettingsPresenter: BlikCustomerLabelUpdateDelegate {
    func didUpdateBlikCustomerLabel(with newBlikLabel: String) {
        let newViewModel = OtherBlikSettingsViewModel(
            blikCustomerLabel: newBlikLabel,
            isTransactionVisible: viewModel.isTransactionVisible
        )
        self.viewModel = newViewModel
        view?.setViewModel(viewModel: newViewModel)
    }
}
    
private extension OtherBlikSettingsPresenter{
    func tryToUpdateWalletAndShowSuccessAlert() {
        Scenario(useCase: loadWalletUseCase)
            .execute(on: useCaseHandler)
            .onSuccess { [weak self] response in
                self?.view?.hideLoader(completion: {
                    switch response.serviceStatus {
                    case let .available(newWallet):
                        self?.updateWalletAndShowSuccessAlert(with: newWallet)
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
    
    func updateWalletAndShowSuccessAlert(with newWallet: GetWalletUseCaseOkOutput.Wallet) {
        wallet.setValue(newWallet)
        let newViewModel = OtherBlikSettingsViewModel(
            blikCustomerLabel: newWallet.alias.label,
            isTransactionVisible: newWallet.noPinTrnVisible
        )
        viewModel = newViewModel
        view?.setViewModel(viewModel: newViewModel)
        coordinator.showSaveSettingsSuccessAlert()
    }
}

extension OtherBlikSettingsPresenter {
    var coordinator: OtherBlikSettingsCoordinatorProtocol {
        dependenciesResolver.resolve()
    }
    
    var saveTransactionVisibilityUseCase: SaveBlikTransactionDataVisibilityUseCaseProtocol {
        dependenciesResolver.resolve()
    }
    
    var loadWalletUseCase: GetWalletsActiveUseCase {
        dependenciesResolver.resolve()
    }
    
    var useCaseHandler: UseCaseHandler {
        dependenciesResolver.resolve()
    }
}

//
//  BlikSettingsPresenter.swift
//  BLIK
//
//  Created by 185167 on 30/11/2021.
//

import CoreFoundationLib
import PLCommons

protocol BlikSettingsPresenterProtocol {
    var view: BlikSettingsView? { get set }
    func didSelectSettingsItem(with viewModel: BlikSettingsViewModel)
    func didTapBack()
    func didTapClose()
}

final class BlikSettingsPresenter {
    private let dependenciesResolver: DependenciesResolver
    private var walletParams: WalletParams?
    weak var view: BlikSettingsView?
    
    private var coordinator: BlikSettingsCoordinatorProtocol {
        dependenciesResolver.resolve()
    }
    
    private var getWalletParamsUseCase: LoadWalletParamsUseCaseProtocol {
        dependenciesResolver.resolve()
    }
    
    private var useCaseHandler: UseCaseHandler {
        dependenciesResolver.resolve()
    }
    
    init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
    }
}

extension BlikSettingsPresenter: BlikSettingsPresenterProtocol {
    func didSelectSettingsItem(with viewModel: BlikSettingsViewModel) {
        switch viewModel {
        case .aliasPayment:
            coordinator.showAliasPaymentSettings()
        case .phoneTransfer:
            coordinator.showPhoneTransferSettings()
        case .transferLimits:
            tryToShowTransferLimits()
        case .otherSettings:
            coordinator.showOtherSettings()
        }
    }
    
    func didTapBack() {
        coordinator.back()
    }
    
    func didTapClose() {
        coordinator.closeToGlobalPosition()
    }
}

private extension BlikSettingsPresenter {
    func tryToShowTransferLimits() {
        guard let walletParams = walletParams else {
            fetchWalletParamsAndShowTransferLimits()
            return
        }
        
        coordinator.showTransferLimitsSettings(with: walletParams)
    }
    
    func fetchWalletParamsAndShowTransferLimits() {
        view?.showLoader()
        Scenario(useCase: getWalletParamsUseCase)
            .execute(on: useCaseHandler)
            .onSuccess { [weak self] output in
                self?.view?.hideLoader(completion: {
                    guard let strongSelf = self else { return }
                    strongSelf.walletParams = output.walletParams
                    strongSelf.coordinator.showTransferLimitsSettings(with: output.walletParams)
                })
            }
            .onError { [weak self] error in
                self?.view?.hideLoader(completion: {
                    self?.view?.showServiceInaccessibleMessage(onConfirm: { [weak self] in
                        self?.coordinator.back()
                    })
                })
            }
    }
}

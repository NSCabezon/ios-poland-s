//
//  PLSavingsCustomOptionCoordinator.swift
//  Santander
//
//  Created by Marcos Álvarez Mesa on 26/4/22.
//

import Foundation
import SavingProducts
import UI
import CoreDomain
import CoreFoundationLib
import GlobalPosition
import OpenCombine

final class PLSavingsCustomOptionCoordinator: BindableCoordinator {
    var dataBinding: DataBinding = DataBindingObject()
    var onFinish: (() -> Void)?
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController?
    private var externalDependenciesResolver: SavingsHomeExternalDependenciesResolver & SavingsGlobalPositionDependenciesResolver
    private var legacyDependenciesResolver: DependenciesResolver
    private var subscriptions: Set<AnyCancellable> = []

    init(dependencies: SavingsHomeExternalDependenciesResolver & SavingsGlobalPositionDependenciesResolver, navigationController: UINavigationController?) {
        self.externalDependenciesResolver = dependencies
        self.navigationController = navigationController
        legacyDependenciesResolver = dependencies.resolve()
    }

    func start() {
        var identifier: String = ""
        if let optionType: SavingProductOptionType = dataBinding.get() {
            if case .custom(let customIdentifier) = optionType {
                identifier = customIdentifier
            }
        }

        switch identifier {
        case PLSavingProductOption.savingDetails.rawValue.lowercased(), PLSavingProductOption.termDetails.rawValue.lowercased():
            didSelectSavingDetail()
        case PLSavingProductOption.sendMoneyFromSrc.rawValue.lowercased():
            didSelectSendMoney()
        case PLSavingProductOption.changeAlias.rawValue.lowercased():
            didSelectChangeAlias()
        default:
            Toast.show(localized("generic_alert_notAvailableOperation"))
        }
    }
}

private extension PLSavingsCustomOptionCoordinator {
    func didSelectSavingDetail() {
        guard let saving: SavingProductRepresentable = dataBinding.get() else { return }
        let coordinator = externalDependenciesResolver.savingDetailCoordinator()
        coordinator.set(saving)
            .start()
        append(child: coordinator)
    }

    func didSelectChangeAlias() {
        let gpNavigator: GlobalPositionModuleCoordinatorDelegate = externalDependenciesResolver.resolve()
        let localAppConfig: LocalAppConfig = externalDependenciesResolver.resolve()
        if localAppConfig.isEnabledConfigureWhatYouSee {
            gpNavigator.didSelectConfigureGPProducts()
        } else {
            ToastCoordinator("generic_alert_notAvailableOperation").start()
        }
    }

    func didSelectSendMoney() {
        checkNewSendMoneyHomeIsEnabled
            .fetchEnabled()
            .receive(on: Schedulers.main)
            .sink { [unowned self] isEnabled in
                if isEnabled {
                    self.externalDependenciesResolver.savingsOneTransferHomeCoordinator().start()
                } else {
                    self.externalDependenciesResolver.savingsSendMoneyCoordinator().start()
                }
            }
            .store(in: &subscriptions)
    }

    var checkNewSendMoneyHomeIsEnabled: SavingsCheckNewHomeSendMoneyIsEnabledUseCase {
        return externalDependenciesResolver.resolve()
    }
}

//
//  PaymentsPGFrequentOperativeOption.swift
//  Santander
//
//  Created by Rodrigo Jurado on 27/5/21.
//

import CoreFoundationLib
import OpenCombine
import RetailLegacy

final class PaymentsPGFrequentOperativeOption {
    let trackName: String? = "enviar_dinero"
    let rawValue: String = "paymentsPoland"
    let accessibilityIdentifier: String? = PLAccessibilityPGFrequentOperatives.btnPayments.rawValue
    private let legacyDependenciesResolver: DependenciesResolver
    private let dependencies: ModuleDependencies
    
    private var subscriptions: Set<AnyCancellable> = []
    
    init(dependencies: ModuleDependencies) {
        self.dependencies = dependencies
        self.legacyDependenciesResolver = dependencies.resolve()
    }
}

extension PaymentsPGFrequentOperativeOption: PGFrequentOperativeOptionProtocol {
    func getAction() -> PGFrequentOperativeOptionAction {
        return .custom { [weak self] in
            guard let self = self else { return }
            self.checkNewSendMoneyHomeIsEnabled
                .fetchEnabled()
                .receive(on: Schedulers.main)
                .sink { [unowned self] isEnabled in
                    if isEnabled {
                        self.dependencies.transferHomeCoordinator().start()
                    } else {
                        self.sendMoneyCoordinator.start()
                    }
                }
                .store(in: &self.subscriptions)
        }
    }
    
    func getViewType(isSmartGP: Bool) -> ActionButtonFillViewType {
        let imageKey: String = "icnSendMoney"
        let titleKey: String = "frequentOperative_button_sendMoney"
        return .defaultButton(
            DefaultActionButtonViewModel(
                title: titleKey,
                imageKey: imageKey,
                titleAccessibilityIdentifier: titleKey,
                imageAccessibilityIdentifier: imageKey
            )
        )
    }
    
    func getEnabled() -> PGFrequentOperativeOptionEnabled {
        return .custom(enabled: { return true })
    }
    
    func getLocation() -> String? {
        return nil
    }
}

private extension PaymentsPGFrequentOperativeOption {
    var checkNewSendMoneyHomeIsEnabled: CheckNewSendMoneyHomeEnabledUseCase {
        return dependencies.resolve()
    }
    
    var sendMoneyCoordinator: SendMoneyCoordinatorProtocol {
        return legacyDependenciesResolver.resolve()
    }
}

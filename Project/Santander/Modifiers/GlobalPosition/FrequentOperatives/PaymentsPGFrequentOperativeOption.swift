//
//  PaymentsPGFrequentOperativeOption.swift
//  Santander
//
//  Created by Rodrigo Jurado on 27/5/21.
//

import CoreFoundationLib
import UI

final class PaymentsPGFrequentOperativeOption {
    let trackName: String? = "enviar_dinero"
    let rawValue: String = "paymentsPoland"
    let accessibilityIdentifier: String? = PLAccessibilityPGFrequentOperatives.btnPayments.rawValue
    private let dependenciesResolver: DependenciesResolver
    
    init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
    }
}

extension PaymentsPGFrequentOperativeOption: PGFrequentOperativeOptionProtocol {
    func getAction() -> PGFrequentOperativeOptionAction {
        return .custom {
            let useCase = CheckNewSendMoneyEnabledUseCase(dependenciesResolver: self.dependenciesResolver)
            Scenario(useCase: useCase)
                .execute(on: self.dependenciesResolver.resolve())
                .onSuccess { [weak self] enabled in
                    if enabled {
                        self?.dependenciesResolver.resolve(for: SendMoneyCoordinatorProtocol.self).start()
                    } else {
                        Toast.show(localized("generic_alert_notAvailableOperation"))
                    }
                }
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

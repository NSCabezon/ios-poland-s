//
//  PLPhoneTopUpOperative.swift
//  Santander
//

import CoreFoundationLib
import UI
import Commons
import PLCommonOperatives
import PhoneTopUp

final class PLPhoneTopUpOperative: AccountOperativeActionTypeProtocol {
    let dependenciesResolver: DependenciesResolver
    #warning("todo: change below when icons and texts are available")
    var rawValue: String = "topUpPoland"
    var trackName: String? = "topUpPoland"
    var accessibilityIdentifier: String? = "accountOption_button_topup"
    private let title: String = "accountOption_button_topup"
    private let icon: String = "icnDonations"
    
    init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
    }

    func values() -> (title: String, imageName: String) {
        return (self.title, self.icon)
    }

    func getViewType(isSmartGP: Bool) -> ActionButtonFillViewType {
        return .defaultButton(DefaultActionButtonViewModel(title: self.title,
                                                           imageKey: self.icon,
                                                           titleAccessibilityIdentifier: self.accessibilityIdentifier ?? "",
                                                           imageAccessibilityIdentifier: self.icon))
    }

    func getAction() -> AccountOperativeAction {
        return .custom {
            let coordinator = self.dependenciesResolver.resolve(for: TopUpDataLoaderCoordinatorProtocol.self)
            UIApplication.shared.keyWindow?.rootViewController?.dismiss(animated: true, completion: {
                coordinator.start()
            })
        }
    }
}

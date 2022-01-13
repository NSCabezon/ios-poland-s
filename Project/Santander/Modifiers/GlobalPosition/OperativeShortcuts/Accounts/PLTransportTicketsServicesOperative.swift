//
//  PLTransportTicketsServicesOperative.swift
//  Santander
//
//  Created by Julio Nieto Santiago on 3/1/22.
//

import CoreFoundationLib
import Commons
import UI

final class PLTransportTicketsServicesOperative: AccountOperativeActionTypeProtocol {
    var rawValue: String = "TransportTicketsServicesPoland"
    var accessibilityIdentifier: String?
    var trackName: String? = "TransportTicketsServicesPoland"
    var title: String = "accountOption_button_services"
    var icon: String = "icnMcommerce"
    
    func values() -> (title: String, imageName: String) {
        return (title: self.title, imageName: self.icon)
    }
        
    func getViewType(isSmartGP: Bool) -> ActionButtonFillViewType {
        return .defaultButton(DefaultActionButtonViewModel(title: self.title,
                                                           imageKey: self.icon,
                                                           titleAccessibilityIdentifier: self.accessibilityIdentifier ?? "",
                                                           imageAccessibilityIdentifier: self.icon))
    }
    
    func getAction() -> AccountOperativeAction {
        return .custom {
            Toast.show(localized("generic_alert_notAvailableOperation"))
        }
    }
}

//
//  PLSendMoneyOperative.swift
//  Santander
//

import CoreFoundationLib
import UI
import UIKit

final class PLSendMoneyOperative: AccountOperativeActionTypeProtocol {
    let dependenciesResolver: DependenciesResolver
    var rawValue: String = "accountOptionButtonTransferPoland"
    var trackName: String? = "accountOptionButtonTransferPoland"
    var accessibilityIdentifier: String? = "accountOptionButtonTransfer"
    private let title: String = "accountOption_button_transfer"
    private let icon: String = "icnSendMoney"

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
            UIApplication.shared.keyWindow?.rootViewController?.dismiss(animated: true, completion: {
                self.dependenciesResolver.resolve(for: SendMoneyCoordinatorProtocol.self).start()
            })
        }
    }
}

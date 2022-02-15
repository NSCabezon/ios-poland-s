//
//  PLMakeDonationOperative.swift
//  Santander
//

import CoreFoundationLib
import UI
import PLCommonOperatives
import CharityTransfer

final class PLMakeDonationOperative: AccountOperativeActionTypeProtocol {
    let dependenciesResolver: DependenciesResolver
    var rawValue: String = "makeDonationPoland"
    var trackName: String? = "makeDonationPoland"
    var accessibilityIdentifier: String? = "accountOption_button_donations"
    private let title: String = "accountOption_button_donations"
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
            let coordinator = self.dependenciesResolver.resolve(
                for: CharityTransferModuleCoordinator.self
            )
            UIApplication.shared.keyWindow?.rootViewController?.dismiss(
                animated: true,
                completion: {
                    coordinator.start()
                })
        }
    }
}

//
//  PLPayTaxOperative.swift
//  Santander
//

import CoreFoundationLib
import UI
import Commons
import TaxTransfer

final class PLPayTaxOperative: AccountOperativeActionTypeProtocol {
    let dependenciesResolver: DependenciesResolver
    var rawValue: String = "payTaxPoland"
    var trackName: String? = "payTaxPoland"
    var accessibilityIdentifier: String? = "accountOptionButtonPayTaxes"
    private let title: String = "accountOption_button_payTaxes"
    private let icon: String = "icnPayTax"
    
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
            let rootViewController = UIApplication.shared.keyWindow?.rootViewController
            rootViewController?.dismiss(animated: true, completion: { [weak self] in
                let coordinator = self?.dependenciesResolver.resolve(for: TaxTransferFormCoordinatorProtocol.self)
                coordinator?.start()
            })
        }
    }
}

//
//  PLBlikOperative.swift
//  Santander
//

import CoreFoundationLib
import UI
import BLIK

final class PLBlikOperative: AccountOperativeActionTypeProtocol {
    private let dependenciesResolver: DependenciesResolver
    var rawValue: String = "blik"
    var trackName: String? = "blik"
    var accessibilityIdentifier: String? = "ptFrequentOperativeButtonBlikPoland"
    private let title: String = "pl_frequentOperative_button_blik"
    private let icon: String = "icnBlik"
    
    init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
    }

    func values() -> (title: String, imageName: String) {
        return (self.title, self.icon)
    }

    func getViewType(isSmartGP: Bool) -> ActionButtonFillViewType {
        return .defaultButton(DefaultActionButtonViewModel(title: self.title,
                                                           imageKey: self.icon,
                                                           renderingMode: .alwaysOriginal,
                                                           titleAccessibilityIdentifier: self.accessibilityIdentifier ?? "",
                                                           imageAccessibilityIdentifier: self.icon))
    }

    func getAction() -> AccountOperativeAction {
        return .custom {[weak self] in
            guard let self = self else { return }
            let blikCoordinator: BLIKHomeCoordinator = self.dependenciesResolver.resolve()
            UIApplication.shared.keyWindow?.rootViewController?.dismiss(animated: true, completion: {
                blikCoordinator.start()
            })
        }
    }
}

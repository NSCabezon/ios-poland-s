//
//  PLTransferZusSmeOperative.swift
//  Santander
//
//  Created by 187830 on 12/04/2022.
//

import CoreFoundationLib
import UI
import PLCommonOperatives
import ZusSMETransfer

final class PLTransferZusSmeOperative: AccountOperativeActionTypeProtocol {
    #warning("TODO - for testers: change below when icons and texts are available")
    let rawValue: String = "transferZusSmePoland"
    let trackName: String? = "transferZusSmePoland"
    let accessibilityIdentifier: String? = "accountOptionButtonTransferZusSme"
    private let dependenciesResolver: DependenciesResolver
    private let title: String = "accountOption_button_TransferZusSme"
    private let icon: String = "icnPayTax"
    
    init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
    }

    func values() -> (title: String, imageName: String) {
        return (title, icon)
    }

    func getViewType(isSmartGP: Bool) -> ActionButtonFillViewType {
        return .defaultButton(
            DefaultActionButtonViewModel(
                title: title,
                imageKey: icon,
                titleAccessibilityIdentifier: accessibilityIdentifier ?? "",
                imageAccessibilityIdentifier: icon
            )
        )
    }

    func getAction() -> AccountOperativeAction {
        return .custom {
            let coordinator = self.dependenciesResolver.resolve(
                for: ZusSmeTransferDataLoaderCoordinatorProtocol.self
            )
            UIApplication.shared.keyWindow?.rootViewController?.dismiss(
                animated: true,
                completion: {
                    coordinator.start()
                })
        }
    }
}

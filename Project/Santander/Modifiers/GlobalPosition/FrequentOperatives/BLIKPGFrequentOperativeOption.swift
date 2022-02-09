//
//  BLIKPGFrequentOperativeOption.swift
//  Santander
//
//  Created by Rodrigo Jurado on 26/5/21.
//

import CoreFoundationLib
import UI
import BLIK

final class BLIKPGFrequentOperativeOption {
    let trackName: String? = "blik_pl"
    let rawValue: String = "blikPoland"
    let accessibilityIdentifier: String? = PLAccessibilityPGFrequentOperatives.btnBlik.rawValue
    
    private let dependencyResolver: DependenciesResolver
   
    init(dependencyResolver: DependenciesResolver) {
        self.dependencyResolver = dependencyResolver
    }
}

extension BLIKPGFrequentOperativeOption: PGFrequentOperativeOptionProtocol {
    func getAction() -> PGFrequentOperativeOptionAction {
        return .custom {[weak self] in
            guard let self = self else { return }
            let blikCoordinator: BLIKHomeCoordinator = self.dependencyResolver.resolve()
            blikCoordinator.start()
        }
    }

    func getViewType(isSmartGP: Bool) -> ActionButtonFillViewType {
        let imageKey: String = "icnBlik"
        let titleKey: String = "pt_frequentOperative_button_blik"
        return .defaultButton(
            DefaultActionButtonViewModel(
                title: titleKey,
                imageKey: imageKey,
                renderingMode: .alwaysOriginal,
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

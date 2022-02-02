//
//  PLHelpCenterFrequentOperativeOption.swift
//  Santander
//
//  Created by 186493 on 20/08/2021.
//

import CoreFoundationLib
import UI
import PLHelpCenter

final class PLHelpCenterFrequentOperativeOption {
    let trackName: String? = "helpCenter_pl" // TODO: Not sure if value is correct
    let rawValue: String = "helpCenterPoland" // TODO: Not sure if value is correct
    let accessibilityIdentifier: String? = PLAccessibilityPGFrequentOperatives.btnHelpCenter.rawValue
    
    private let dependencyResolver: DependenciesResolver
   
    init(dependencyResolver: DependenciesResolver) {
        self.dependencyResolver = dependencyResolver
    }
}

extension PLHelpCenterFrequentOperativeOption: PGFrequentOperativeOptionProtocol {
    func getAction() -> PGFrequentOperativeOptionAction {
        return .custom {[weak self] in
            guard let self = self else { return }
            let helpCenterCoordinator: PLHelpCenterModuleCoordinator = self.dependencyResolver.resolve()
            helpCenterCoordinator.start()
        }
    }

    func getViewType(isSmartGP: Bool) -> ActionButtonFillViewType {
        let imageKey: String = "icnSupportMenu"
        let titleKey: String = "frequentOperative_label_customerCare"
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

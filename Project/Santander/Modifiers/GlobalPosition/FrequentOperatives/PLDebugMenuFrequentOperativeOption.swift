//
//  PLDebugMenuFrequentOperativeOption.swift
//  Santander
//
//  Created by 186493 on 16/09/2021.
//

import CoreFoundationLib
import UI
import CoreFoundationLib
import PLHelpCenter

// Temporary [DEBUG MENU] on GlobalPosition - whole file
final class PLDebugMenuFrequentOperativeOption {
    let trackName: String? = "debugMenu_pl"
    let rawValue: String = "debugMenyPoland"
    let accessibilityIdentifier: String? = PLAccessibilityPGFrequentOperatives.btnDebugMenu.rawValue
    private var oneAppInitCoordinator: OneAppInitCoordinatorProtocol?
    
    private let dependencyResolver: DependenciesResolver
   
    init(dependencyResolver: DependenciesResolver) {
        self.dependencyResolver = dependencyResolver
    }
}

extension PLDebugMenuFrequentOperativeOption: PGFrequentOperativeOptionProtocol {
    func getAction() -> PGFrequentOperativeOptionAction {
        return .custom { [weak self] in
            guard let self = self else { return }
            
            self.oneAppInitCoordinator = self.dependencyResolver.resolve(for: OneAppInitCoordinatorProtocol.self)
            self.oneAppInitCoordinator?.startWithoutMocks()
        }
    }

    func getViewType(isSmartGP: Bool) -> ActionButtonFillViewType {
        let imageKey: String = "icnServicesSmall"
        let titleKey: String = "DEBUG MENU"
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

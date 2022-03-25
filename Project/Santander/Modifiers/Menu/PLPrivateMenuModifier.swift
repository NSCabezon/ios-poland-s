//
//  PLPrivateMenuModifier.swift
//  Santander
//
//  Created by Mario Rosales Maillo on 13/12/21.
//

import CoreFoundationLib
import PLHelpCenter
import RetailLegacy
import UI

final class PLPrivateMenuModifier: PrivateMenuProtocol {
    private var legacyDependenciesResolver: DependenciesResolver
    private var dependencies: ModuleDependencies
    
    public init(dependencies: ModuleDependencies) {
        self.legacyDependenciesResolver = dependencies.resolve()
        self.dependencies = dependencies
    }
    
    func goToPaymentsLandingPage() {
        showComingSoonMessage()
    }
    
    func goToTopUpLandingPage() {
        showComingSoonMessage()
    }
    
    func goToFinanceLandingPage() {
        showComingSoonMessage()
    }
    
    func goToHelpCenterPage() {
        legacyDependenciesResolver.resolve(for: PLHelpCenterModuleCoordinator.self).start()
    }
}

private extension PLPrivateMenuModifier {
    private func showComingSoonMessage() {
        Toast.show(localized("generic_alert_notAvailableOperation"))
    }
}

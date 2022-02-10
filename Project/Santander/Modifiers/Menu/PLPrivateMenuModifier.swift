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
    private var dependenciesResolver: DependenciesResolver
    private var coreDependenciesResolver: RetailLegacyExternalDependenciesResolver
    
    public init(resolver: DependenciesResolver, coreDependenciesResolver: RetailLegacyExternalDependenciesResolver) {
        self.dependenciesResolver = resolver
        self.coreDependenciesResolver = coreDependenciesResolver
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
        dependenciesResolver.resolve(for: PLHelpCenterModuleCoordinator.self).start()
    }
    
    func goToOneTransferHome() {
        coreDependenciesResolver.oneTransferHomeCoordinator().start()
    }
}

private extension PLPrivateMenuModifier {
    private func showComingSoonMessage() {
        Toast.show(localized("generic_alert_notAvailableOperation"))
    }
}

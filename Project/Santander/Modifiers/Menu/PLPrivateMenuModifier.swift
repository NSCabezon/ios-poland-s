//
//  PLPrivateMenuModifier.swift
//  Santander
//
//  Created by Mario Rosales Maillo on 13/12/21.
//

import Foundation
import Commons
import UI
import PLHelpCenter

final class PLPrivateMenuModifier: PrivateMenuProtocol {
    private var dependenciesResolver: DependenciesResolver
    
    public init(resolver: DependenciesResolver) {
        self.dependenciesResolver = resolver
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
}

private extension PLPrivateMenuModifier {
    private func showComingSoonMessage() {
        Toast.show(localized("generic_alert_notAvailableOperation"))
    }
}

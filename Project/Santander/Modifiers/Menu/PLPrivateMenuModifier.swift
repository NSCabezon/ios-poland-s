//
//  PLPrivateMenuModifier.swift
//  Santander
//
//  Created by Mario Rosales Maillo on 13/12/21.
//

import PLHelpCenter
import Transfer
import Commons
import UI

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
    
    func goToOneTransferHome() {
        dependenciesResolver.resolve(for: OneTransferHomeExternalDependenciesResolver.self).oneTransferHomeCoordinator().start()
    }
}

private extension PLPrivateMenuModifier {
    private func showComingSoonMessage() {
        Toast.show(localized("generic_alert_notAvailableOperation"))
    }
}

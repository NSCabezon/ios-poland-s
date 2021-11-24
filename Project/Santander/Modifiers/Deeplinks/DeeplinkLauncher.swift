//
//  DeeplinkLauncher.swift
//  Santander
//
//  Created by Francisco del Real Escudero on 13/4/21.
//

import Commons
import RetailLegacy
import Models

import PLHelpCenter
import BLIK

struct DeeplinkLauncher {
    private let dependenciesResolver: DependenciesResolver
    
    init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
    }
}

extension DeeplinkLauncher: CustomDeeplinkLauncher {
    func launch(deeplink: String, with userInfo: [DeepLinkUserInfoKeys: String]) {
        guard let polandDeepLink = PolandDeepLink(deeplink, userInfo: userInfo) else { return }
        self.launch(polandDeepLink: polandDeepLink)
    }
    
    func launch(deeplink: DeepLinkEnumerationCapable) {
        guard let polandDeepLink = deeplink as? PolandDeepLink else { return }
        self.launch(polandDeepLink: polandDeepLink)
    }
}

private extension DeeplinkLauncher {
    func launch(polandDeepLink: PolandDeepLink) {
        switch polandDeepLink {
        case .helpCenter:
            dependenciesResolver.resolve(for: PLHelpCenterModuleCoordinator.self).start()
        case .contact:
            dependenciesResolver.resolve(for: PLHelpCenterModuleCoordinator.self).start()
        case .blikTransaction:
            dependenciesResolver.resolve(for: DeeplinkedBLIKConfirmationCoordinator.self).start()
        }
    }
}

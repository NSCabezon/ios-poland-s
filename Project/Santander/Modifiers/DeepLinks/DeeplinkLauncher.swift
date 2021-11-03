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

struct DeeplinkLauncher {
    private let dependenciesResolver: DependenciesResolver
    
    init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
    }
}

extension DeeplinkLauncher: CustomDeeplinkLauncher {
    func launch(deeplink: String, with userInfo: [DeepLinkUserInfoKeys: String]) {
        guard let PolandDeepLink = PolandDeepLink(deeplink, userInfo: userInfo) else { return }
        self.launch(PolandDeepLink: PolandDeepLink)
    }
    
    func launch(deeplink: DeepLinkEnumerationCapable) {
        guard let PolandDeepLink = deeplink as? PolandDeepLink else { return }
        self.launch(PolandDeepLink: PolandDeepLink)
    }
}

private extension DeeplinkLauncher {
    func launch(PolandDeepLink: PolandDeepLink) {
        switch PolandDeepLink {
        case .helpCenter:
            dependenciesResolver.resolve(for: PLHelpCenterModuleCoordinator.self).start()
        case .contact:
            dependenciesResolver.resolve(for: PLHelpCenterModuleCoordinator.self).start()
        }
    }
}

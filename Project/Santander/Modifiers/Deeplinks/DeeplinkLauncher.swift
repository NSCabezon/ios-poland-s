//
//  DeeplinkLauncher.swift
//  Santander
//
//  Created by Francisco del Real Escudero on 13/4/21.
//

import CoreFoundationLib
import RetailLegacy
import PLCommons
import PLCommonOperatives
import UI
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
        case .ourOffer:
            openOurOffer()
        case .alertsNotification:
            openAlertsNotification()
        case .sendMoney:
            dependenciesResolver.resolve(for: SendMoneyCoordinatorProtocol.self).start()
        case .services:
            Toast.show(localized("generic_alert_notAvailableOperation"))
        case .blik:
            dependenciesResolver.resolve(for: BLIKHomeCoordinator.self).start()
        case .myProducts(let entryType, let mediumType, let subjectID, let baseAddress):
            let cordinator = dependenciesResolver.resolve(for: OnlineAdvisorCoordinatorProtocol.self)
            cordinator.startAfterLogin(entryType: entryType, mediumType: mediumType, subjectId: subjectID, baseAddress: baseAddress)
        case .onlineAdvisor(let params):
            var cordinator = dependenciesResolver.resolve(for: OnlineAdvisorCoordinatorProtocol.self)
            cordinator.presenter?.onlineAdvisorParameters = params
            cordinator.start()
        }
    }
    
    func openOurOffer(){
        openWebViewByType(.ourOffer)        
    }
    
    func openAlertsNotification() {
        openWebViewByType(.alerts24)
    }
    
    func openWebViewByType(_ type: PLAccountOperativeIdentifier ){
        let repository = self.dependenciesResolver.resolve(for: PLAccountOtherOperativesInfoRepository.self)

        guard let options = repository.get()?.accountsOptions,
              let option = options.first(where: { $0.id == type.rawValue }),
              option.isAvailable ?? true,
              let url = option.url,
              let method = option.method,
              let methodType = HTTPMethodType(rawValue: method)
        else {
            Toast.show(localized("generic_alert_notAvailableOperation"))
            return
        }

        let input = GetBasePLWebConfigurationUseCaseInput(initialURL: url, method: methodType, isFullScreenEnabled: option.isFullScreen)
        let webViewCoordinator = self.dependenciesResolver.resolve(for: PLWebViewCoordinatorDelegate.self)
        let useCase = self.dependenciesResolver.resolve(for: GetBasePLWebConfigurationUseCaseProtocol.self)
        
        Scenario(useCase: useCase, input: input)
            .execute(on: self.dependenciesResolver.resolve())
            .onSuccess { result in
                let handler = PLWebviewCustomLinkHandler(configuration: result.configuration)
                webViewCoordinator.showWebView(handler: handler)
            }
            .onError { error in
                Toast.show(error.getErrorDesc() ?? "")
            }
    }
}

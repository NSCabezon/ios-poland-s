//
//  CurrencyExchangePGFrequentOperativeOption.swift
//  Santander
//
//  Created by Ernesto Fernandez Calles on 2/8/21.
//

import CoreFoundationLib
import UI
import PLCommons
import PLCommonOperatives

final class CurrencyExchangePGFrequentOperativeOption {
    let trackName: String? = "currencyExchange"
    let rawValue: String = "currencyExchangePoland"
    let accessibilityIdentifier: String? = PLAccessibilityPGFrequentOperatives.currencyExchange.rawValue
    private let optionId: String = PLAccountOtherOperativesIdentifier.fxExchange.rawValue
    
    private let dependenciesResolver: DependenciesResolver
    
    init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
    }
}

extension CurrencyExchangePGFrequentOperativeOption: PGFrequentOperativeOptionProtocol {
    func getAction() -> PGFrequentOperativeOptionAction {
        return .custom { [weak self] in
            guard let self = self else { return }
            let repository = self.dependenciesResolver.resolve(for: PLWebViewLinkRepositoryProtocol.self)
            guard let webViewLink = repository.getWebViewLink(forIdentifier: self.optionId) else { return }
            guard webViewLink.isAvailable else {
                return Toast.show(localized("generic_alert_notAvailableOperation"))
            }
            
            let input = GetBasePLWebConfigurationUseCaseInput(webViewLink: webViewLink)
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

    func getViewType(isSmartGP: Bool) -> ActionButtonFillViewType {
        let imageKey: String = "icnCurrencyExchange"
        let titleKey: String = "accountOption_button_currencyExchange"
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

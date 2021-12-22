//
//  OurOfferPGFrequentOperativeOption.swift
//  Santander
//
//  Created by Ernesto Fernandez Calles on 3/8/21.
//

import Models
import UI
import Commons
import PLCommons
import PLCommonOperatives

final class OurOfferPGFrequentOperativeOption {
    let trackName: String? = "ourOffer"
    let rawValue: String = "ourOfferPoland"
    let accessibilityIdentifier: String? = PLAccessibilityPGFrequentOperatives.exploreProducts.rawValue
    private let optionId: String = PLAccountOtherOperativesIdentifier.exploreProducts.rawValue
    private let dependenciesResolver: DependenciesResolver
    
    init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
    }
}

extension OurOfferPGFrequentOperativeOption: PGFrequentOperativeOptionProtocol {
    func getAction() -> PGFrequentOperativeOptionAction {
        return .custom { [weak self] in
            guard let self = self else {
                Toast.show(localized("generic_alert_notAvailableOperation"))
                return
            }
            let repository = self.dependenciesResolver.resolve(for: PLAccountOtherOperativesInfoRepository.self)

            guard let options = repository.get()?.accountsOptions,
                  let option = options.first(where: { $0.id == self.optionId }),
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

    func getViewType(isSmartGP: Bool) -> ActionButtonFillViewType {
        let imageKey: String = "icnOffer"
        let titleKey: String = "frequentOperative_button_contract"
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

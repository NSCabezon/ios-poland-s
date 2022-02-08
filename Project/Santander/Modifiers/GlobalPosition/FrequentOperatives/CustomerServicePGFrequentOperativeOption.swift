//
//  CustomerServicePGFrequentOperativeOption.swift
//  Santander
//
//  Created by Ernesto Fernandez Calles on 2/8/21.
//

import CoreFoundationLib
import UI
import PLCommons
import PLCommonOperatives

final class CustomerServicePGFrequentOperativeOption {
    let trackName: String? = "customerService"
    let rawValue: String = "customerServicePoland"
    
    let accessibilityIdentifier: String? = PLAccessibilityPGFrequentOperatives.customerService.rawValue
    private let optionId: String = PLAccountOtherOperativesIdentifier.customerService.rawValue
    private let dependenciesResolver: DependenciesResolver
   
    init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
    }
}

extension CustomerServicePGFrequentOperativeOption: PGFrequentOperativeOptionProtocol {
    func getAction() -> PGFrequentOperativeOptionAction {
        return .custom {
            let repository = self.dependenciesResolver.resolve(for: PLAccountOtherOperativesInfoRepository.self)
            
            guard let options = repository.get()?.accountsOptions,
                  let option = options.first(where: { $0.id == self.optionId }),
                  option.isAvailable ?? true,
                  let url = option.url
            else {
                Toast.show(localized("generic_alert_notAvailableOperation"))
                return
            }

            let input = GetBasePLWebConfigurationUseCaseInput(initialURL: url)
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
        let imageKey: String = "icnCustomerService"
        let titleKey: String = "accountOption_button_customerService"
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

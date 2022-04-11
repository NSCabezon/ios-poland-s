//
//  OpenDepositPGFrequentOperativeOption.swift
//  Santander
//
//  Created by Ernesto Fernandez Calles on 2/8/21.
//

import CoreFoundationLib
import UI
import PLCommons
import PLCommonOperatives

final class OpenDepositPGFrequentOperativeOption {
    let trackName: String? = "openDeposit"
    let rawValue: String = "openDepositPoland"
    let accessibilityIdentifier: String? = PLAccessibilityPGFrequentOperatives.openDeposit.rawValue
    private let optionId: String = PLAccountOperativeIdentifier.openDeposit.rawValue
    private let dependenciesResolver: DependenciesResolver
    
    init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
    }
}

extension OpenDepositPGFrequentOperativeOption: PGFrequentOperativeOptionProtocol {
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
                  let url = option.url
            else {
                Toast.show(localized("generic_alert_notAvailableOperation"))
                return
            }

            let method: HTTPMethodType = self.getHttpMethod(method: option.method)
            let input = GetBasePLWebConfigurationUseCaseInput(initialURL: url, method: method)
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
        let imageKey: String = "icnOpenDeposit"
        let titleKey: String = "accountOption_button_openDeposit" 
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
    
    private func getHttpMethod(method: String?) -> HTTPMethodType {
        if method == "POST" {
            return .post
        } else {
            return .get
        }
    }
}

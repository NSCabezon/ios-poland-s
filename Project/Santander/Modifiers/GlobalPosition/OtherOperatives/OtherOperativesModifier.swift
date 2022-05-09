//
//  OtherOperativesModifier.swift
//  Santander
//

import CreditCardRepayment
import CoreFoundationLib
import GlobalPosition
import PersonalArea
import UI
import RetailLegacy

protocol OtherOperativesModifierDependenciesResolver {
    func resolve() -> CreditCardRepaymentModuleCoordinator
    func resolve() -> PersonalAreaModuleCoordinator
    func resolve() -> GlobalPositionModuleCoordinatorDelegate
}

final class OtherOperativesModifier: OtherOperativesModifierProtocol {
    private let creditCardRepaymentCoordinator: CreditCardRepaymentModuleCoordinator
    private let personalAreaModuleCoordinator: PersonalAreaModuleCoordinator
    private let gpNavigator: GlobalPositionModuleCoordinatorDelegate
    private let localAppConfig: LocalAppConfig

    init(dependencies: OtherOperativesModifierDependenciesResolver, dependenciesResolver: DependenciesResolver) {
        self.creditCardRepaymentCoordinator = dependencies.resolve()
        self.personalAreaModuleCoordinator = dependencies.resolve()
        self.gpNavigator = dependencies.resolve()
        self.localAppConfig = dependenciesResolver.resolve(firstTypeOf: LocalAppConfig.self)
    }
    
    var isStockAccountsDisabled: Bool {
        return true
    }
    
    func isOtherOperativeEnabled(_ option: PGFrequentOperativeOption) -> Bool {
        return true
    }

    func performAction(_ values: OperativeActionValues) {
        switch values.identifier {
        case PLRepaymentOperative.identifier:
            creditCardRepaymentCoordinator.start()
        case PLLoansAliasOperative.rawValue:
            personalAreaModuleCoordinator.goToGPProductsCustomization()
        case PLChangeProductAliasOperative.identifier:
            if localAppConfig.isEnabledConfigureWhatYouSee {
                gpNavigator.didSelectConfigureGPProducts()
            } else {
                Toast.show(localized("generic_alert_notAvailableOperation"))
            }
        default:
            Toast.show(localized("generic_alert_notAvailableOperation"))
        }
    }
}

//
//  OtherOperativesModifier.swift
//  Santander
//

import GlobalPosition
import CoreFoundationLib
import Commons
import UI
import CreditCardRepayment
import PersonalArea

final class OtherOperativesModifier: OtherOperativesModifierProtocol {
    private let dependenciesEngine: DependenciesResolver & DependenciesInjector

    init(dependenciesEngine: DependenciesResolver & DependenciesInjector) {
        self.dependenciesEngine = dependenciesEngine
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
            let coordinator = dependenciesEngine.resolve(for: CreditCardRepaymentModuleCoordinator.self)
            coordinator.start()
        case PLLoansAliasOperative.rawValue:
            let coordinator = dependenciesEngine.resolve(for: PersonalAreaModuleCoordinator.self)
            coordinator.goToGPProductsCustomization()
        default:
            Toast.show(localized("generic_alert_notAvailableOperation"))
        }
    }
}

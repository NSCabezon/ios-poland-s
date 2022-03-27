//
//  OtherOperativesModifier.swift
//  Santander
//

import CreditCardRepayment
import CoreFoundationLib
import GlobalPosition
import PersonalArea
import UI

protocol OtherOperativesModifierDependenciesResolver {
    func resolve() -> CreditCardRepaymentModuleCoordinator
    func resolve() -> PersonalAreaModuleCoordinator
}

final class OtherOperativesModifier: OtherOperativesModifierProtocol {
    private let creditCardRepaymentCoordinator: CreditCardRepaymentModuleCoordinator
    private let personalAreaModuleCoordinator: PersonalAreaModuleCoordinator

    init(dependencies: OtherOperativesModifierDependenciesResolver) {
        self.creditCardRepaymentCoordinator = dependencies.resolve()
        self.personalAreaModuleCoordinator = dependencies.resolve()
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
        default:
            Toast.show(localized("generic_alert_notAvailableOperation"))
        }
    }
}

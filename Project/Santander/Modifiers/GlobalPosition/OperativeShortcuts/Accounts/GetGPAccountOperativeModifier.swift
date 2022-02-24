//
//  GetGPAccountOperativeModifier.swift
//  Santander
//

import CoreFoundationLib
import SANPLLibrary
import RetailLegacy

public final class GetGPAccountOperativeModifier: GetGPAccountOperativeOptionProtocol {
    private let moduleDependencies: ModuleDependencies
    private let dependenciesEngine: DependenciesResolver
    private let managersProvider: PLManagersProviderProtocol
    
    init(moduleDependencies: ModuleDependencies) {
        self.moduleDependencies = moduleDependencies
        self.dependenciesEngine = moduleDependencies.resolve()
        self.managersProvider = moduleDependencies.resolve()
    }
    
    public func getAllAccountOperativeActionType() -> [AccountOperativeActionTypeProtocol] {
        return [
            PLSendMoneyHomeOperativeShortcut(dependencies: moduleDependencies),
            PLDomesticTransferOperative(),
            self.getSwitchBetweenAccount(),
            PLSendMoneyFavouriteOperative(),
            PLBlikOperative(),
            PLMakeDonationOperative(dependenciesResolver: self.dependenciesEngine),
            PLPayTaxOperative(dependenciesResolver: self.dependenciesEngine),
            PLCurrencyExchangeOperative(),
            AccountOperativeActionType.changeAlias,
            PLAccountNotificationsOperative(),
            PLTransportTicketsServicesOperative(),
            PLTransferZusOperative(dependenciesResolver: dependenciesEngine)
        ].compactMap { $0 }
    }
    
    public func getCountryAccountOperativeActionType(accounts: [AccountEntity]) -> [AccountOperativeActionTypeProtocol] {
        return [
            PLSendMoneyHomeOperativeShortcut(dependencies: moduleDependencies),
            PLDomesticTransferOperative(),
            self.getSwitchBetweenAccount(),
            PLSendMoneyFavouriteOperative(),
            PLBlikOperative(),
            PLMakeDonationOperative(dependenciesResolver: self.dependenciesEngine),
            PLPayTaxOperative(dependenciesResolver: self.dependenciesEngine),
            PLCurrencyExchangeOperative(),
            AccountOperativeActionType.changeAlias,
            PLAccountNotificationsOperative(),
            PLTransportTicketsServicesOperative(),
            PLTransferZusOperative(dependenciesResolver: dependenciesEngine)
        ].compactMap { $0 }
    }
}

private extension GetGPAccountOperativeModifier {
    private func getSwitchBetweenAccount() -> AccountOperativeActionTypeProtocol? {
        let accounts = try? self.managersProvider.getGlobalPositionManager().getAllProducts().get().accounts
        let switchBetweenAccountConditional = (accounts?.count ?? 0) > 1
        return switchBetweenAccountConditional ? PLSwitchBetweenAccountOperative() : nil
    }
}

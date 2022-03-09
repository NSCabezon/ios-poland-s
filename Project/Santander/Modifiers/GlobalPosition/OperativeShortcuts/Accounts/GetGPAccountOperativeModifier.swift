//
//  GetGPAccountOperativeModifier.swift
//  Santander
//

import CoreFoundationLib
import SANPLLibrary
import RetailLegacy

public final class GetGPAccountOperativeModifier: GetGPAccountOperativeOptionProtocol {
    private let dependencies: ModuleDependencies
    private let legacyDependenciesResolver: DependenciesResolver
    private let managersProvider: PLManagersProviderProtocol
    
    init(dependencies: ModuleDependencies) {
        self.dependencies = dependencies
        self.legacyDependenciesResolver = dependencies.resolve()
        self.managersProvider = dependencies.resolve()
    }
    
    public func getAllAccountOperativeActionType() -> [AccountOperativeActionTypeProtocol] {
        return [
            PLSendMoneyHomeOperativeShortcut(dependencies: dependencies),
            PLDomesticTransferOperative(),
            self.getSwitchBetweenAccount(),
            PLSendMoneyFavouriteOperative(),
            PLBlikOperative(),
            PLMakeDonationOperative(dependenciesResolver: legacyDependenciesResolver),
            PLCurrencyExchangeOperative(),
            AccountOperativeActionType.changeAlias,
            PLAccountNotificationsOperative(),
            PLTransportTicketsServicesOperative(),
            PLTransferZusOperative(dependenciesResolver: legacyDependenciesResolver)
        ].compactMap { $0 }
    }
    
    public func getCountryAccountOperativeActionType(accounts: [AccountEntity]) -> [AccountOperativeActionTypeProtocol] {
        return [
            PLSendMoneyHomeOperativeShortcut(dependencies: dependencies),
            PLDomesticTransferOperative(),
            self.getSwitchBetweenAccount(),
            PLSendMoneyFavouriteOperative(),
            PLBlikOperative(),
            PLMakeDonationOperative(dependenciesResolver: legacyDependenciesResolver),
            PLCurrencyExchangeOperative(),
            AccountOperativeActionType.changeAlias,
            PLAccountNotificationsOperative(),
            PLTransportTicketsServicesOperative(),
            PLTransferZusOperative(dependenciesResolver: legacyDependenciesResolver)
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

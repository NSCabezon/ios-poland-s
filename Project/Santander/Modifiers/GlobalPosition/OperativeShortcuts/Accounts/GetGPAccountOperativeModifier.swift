//
//  GetGPAccountOperativeModifier.swift
//  Santander
//

import Models
import Commons
import SANPLLibrary

public final class GetGPAccountOperativeModifier: GetGPAccountOperativeOptionProtocol {
    private let dependenciesEngine: DependenciesResolver & DependenciesInjector
    private let managersProvider: PLManagersProviderProtocol

    init(dependenciesEngine: DependenciesResolver & DependenciesInjector) {
        self.dependenciesEngine = dependenciesEngine
        self.managersProvider = dependenciesEngine.resolve(for: PLManagersProviderProtocol.self)
    }

    public func getAllAccountOperativeActionType() -> [AccountOperativeActionTypeProtocol] {
        return [PLSendMoneyOperative(dependenciesResolver: self.dependenciesEngine),
                PLDomesticTransferOperative(),
                self.getSwitchBetweenAccount(),
                PLSendMoneyFavouriteOperative(),
                PLBlikOperative(),
                PLMakeDonationOperative(),
                PLPayTaxOperative(),
                PLCurrencyExchangeOperative(),
                AccountOperativeActionType.changeAlias,
                PLAccountNotificationsOperative()
        ].compactMap { $0 }
    }
    
    public func getCountryAccountOperativeActionType(accounts: [AccountEntity]) -> [AccountOperativeActionTypeProtocol] {
        return [PLSendMoneyOperative(dependenciesResolver: self.dependenciesEngine),
                PLDomesticTransferOperative(),
                self.getSwitchBetweenAccount(),
                PLSendMoneyFavouriteOperative(),
                PLBlikOperative(),
                PLMakeDonationOperative(),
                PLPayTaxOperative(),
                PLCurrencyExchangeOperative(),
                AccountOperativeActionType.changeAlias,
                PLAccountNotificationsOperative()
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

//
//  GetGPAccountOperativeModifier.swift
//  Santander
//

import CoreFoundationLib
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
                PLBlikOperative(dependenciesResolver: self.dependenciesEngine),
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
        return [PLSendMoneyOperative(dependenciesResolver: self.dependenciesEngine),
                PLDomesticTransferOperative(),
                self.getSwitchBetweenAccount(),
                PLSendMoneyFavouriteOperative(),
                PLBlikOperative(dependenciesResolver: self.dependenciesEngine),
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

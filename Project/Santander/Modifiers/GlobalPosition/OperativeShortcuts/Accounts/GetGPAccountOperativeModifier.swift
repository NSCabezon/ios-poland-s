//
//  GetGPAccountOperativeModifier.swift
//  Santander
//

import Models
import Commons

public final class GetGPAccountOperativeModifier: GetGPAccountOperativeOptionProtocol {
    public func getAllAccountOperativeActionType() -> [AccountOperativeActionTypeProtocol] {
        return [PLSendMoneyOperative(),
                PLDomesticTransferOperative(),
                AccountOperativeActionType.internalTransfer,
                PLSendMoneyFavouriteOperative(),
                PLBlikOperative(),
                PLMakeDonationOperative(),
                PLPayTaxOperative(),
                PLCurrencyExchangeOperative(),
                AccountOperativeActionType.changeAlias,
                PLAccountNotificationsOperative()
        ]
    }
    
    public func getCountryAccountOperativeActionType(accounts: [AccountEntity]) -> [AccountOperativeActionTypeProtocol] {
        return [PLSendMoneyOperative(),
                PLDomesticTransferOperative(),
                AccountOperativeActionType.internalTransfer,
                PLSendMoneyFavouriteOperative(),
                PLBlikOperative(),
                PLMakeDonationOperative(),
                PLPayTaxOperative(),
                PLCurrencyExchangeOperative(),
                AccountOperativeActionType.changeAlias,
                PLAccountNotificationsOperative()
        ]
    }
}

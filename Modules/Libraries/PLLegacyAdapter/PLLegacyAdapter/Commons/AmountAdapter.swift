//
//  AmountAdapter.swift
//  PLLegacyAdapter
//
//  Created by Rodrigo Jurado on 19/5/21.
//

import SANPLLibrary
import SANLegacyLibrary

public final class AmountAdapter {
    public func adaptBalanceToAmount(_ balance: BalanceDTO?) -> AmountDTO? {
        guard let amount = balance?.value,
              let currencyCode = balance?.currencyCode,
              let currencyType: CurrencyType = CurrencyType(rawValue: currencyCode) else {
            return nil
        }
        let balanceAmount = Decimal(amount)
        let currencyDTO = CurrencyDTO(currencyName: currencyCode, currencyType: currencyType)
        return AmountDTO(value: balanceAmount, currency: currencyDTO)
    }
}

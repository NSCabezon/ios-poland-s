//
//  AmountAdapter.swift
//  PLLegacyAdapter
//

import SANLegacyLibrary
import SANPLLibrary

public final class AmountAdapter {
    public func adaptBalanceToAmount(_ balance: BalanceDTO?) -> AmountDTO? {
        guard let amount = balance?.valueInBaseCurrency,
              let currencyCode = balance?.currencyCode else {
            return nil
        }
        let currencyType: CurrencyType = CurrencyType.parse(currencyCode)
        let balanceAmount = Decimal(amount)
        let currencyDTO = CurrencyDTO(currencyName: currencyCode, currencyType: currencyType)
        return AmountDTO(value: balanceAmount, currency: currencyDTO)
    }
}

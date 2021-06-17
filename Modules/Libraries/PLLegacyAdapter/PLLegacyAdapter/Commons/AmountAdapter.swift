//
//  AmountAdapter.swift
//  PLLegacyAdapter
//

import SANLegacyLibrary
import SANPLLibrary

public final class AmountAdapter {
    public func adaptBalanceToAmount(_ balance: BalanceDTO?) -> AmountDTO? {
        return makeAmountDTO(value: balance?.value, currencyCode: balance?.currencyCode)
    }

    public func adaptBalanceToCounterValueAmount(_ balance: BalanceDTO?) -> AmountDTO? {
        return makeAmountDTO(value: balance?.valueInBaseCurrency, currencyCode: balance?.currencyCode)
    }
    
    private func makeAmountDTO(value: Double?, currencyCode: String?) -> AmountDTO? {
        guard let amount = value,
              let currencyCode = currencyCode else {
            return nil
        }
        let currencyType: CurrencyType = CurrencyType.parse(currencyCode)
        let balanceAmount = Decimal(amount)
        let currencyDTO = CurrencyDTO(currencyName: currencyCode, currencyType: currencyType)
        return AmountDTO(value: balanceAmount, currency: currencyDTO)
    }
}

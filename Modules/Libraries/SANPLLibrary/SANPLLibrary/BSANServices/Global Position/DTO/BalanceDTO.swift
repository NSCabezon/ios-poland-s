//
//  BalanceDTO.swift
//  SANPLLibrary
//
//  Created by Rodrigo Jurado on 14/5/21.
//

import Foundation
import CoreDomain

public struct BalanceDTO: Codable {
    public let value: Double?
    public let currencyCode: String?
    public let valueInBaseCurrency: Double?

    func adaptBalanceToAmount() -> AmountDTO? {
        return self.makeAmountDTO(value: value, currencyCode: self.currencyCode)
    }
}

private extension BalanceDTO {
    func makeAmountDTO(value: Double?, currencyCode: String?) -> AmountDTO? {
        guard let amount = value,
              let currencyRepresentable = currency else {
            return nil
        }
        let balanceAmount = Decimal(amount)
        return AmountDTO(value: balanceAmount, currencyRepresentable: currencyRepresentable)
    }

    var currency: CurrencyRepresentable? {
        guard let currencyCode = self.currencyCode else {
            return nil
        }
        let currencyType = CurrencyType.parse(currencyCode)
        return CurrencyDTO(currencyName: currencyCode, currencyType: currencyType)
    }
}

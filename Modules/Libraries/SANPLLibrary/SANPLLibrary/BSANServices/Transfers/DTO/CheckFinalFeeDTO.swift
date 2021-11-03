//
//  CheckFinalFeeDTO.swift
//  SANPLLibrary
//
//  Created by Jose Javier Montes Romero on 11/10/21.
//

import SANLegacyLibrary
import CoreDomain

struct CheckFinalFeeDTO: Codable {
    let records: [FeeRecordsDTO]?
    let correlationID: String?
}

struct FeeRecordsDTO: Codable {
    let accountNo: String?
    let serviceId: TransferFeeServiceIdDTO?
    let channelId: Int?
    let operationAmount: BalanceDTO?
    let fee: FeeDTO?
    let calculationRate: CalculationRateDTO?
    let calculationRateToLocal: CalculationRateDTO?
    let totalAmount: BalanceDTO?

}

public enum TransferFeeServiceIdDTO: String, Codable {
    case elixir = "PRZ_ELIXIR"
    case bluecash = "PRZ_BLUE_CASH"
    case expressElixir = "PRZ_EX_ELIXIR"
}

// MARK: - CalculationRate
struct CalculationRateDTO: Codable {
    let value: Int?
    let description: String?
    let date: String?
}

// MARK: - Fee
struct FeeDTO: Codable {
    let description: String?
    let amount: BalanceDTO?
}

private extension FeeRecordsDTO {
    func adaptBalanceToAmount(_ balance: BalanceDTO?) -> AmountDTO? {
        return self.makeAmountDTO(value: balance?.value, currencyCode: balance?.currencyCode)
    }
    
    func makeAmountDTO(value: Double?, currencyCode: String?) -> AmountDTO? {
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

extension FeeRecordsDTO: CheckFinalFeeRepresentable {
    var feeAmount: AmountRepresentable? {
        self.adaptBalanceToAmount(self.fee?.amount)
    }
}

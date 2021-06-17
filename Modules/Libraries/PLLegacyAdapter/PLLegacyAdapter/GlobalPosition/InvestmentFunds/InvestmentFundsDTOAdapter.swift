//
//  InvestmentFundsDTOAdapter.swift
//  PLLegacyAdapter
//

import SANPLLibrary
import SANLegacyLibrary

final class InvestmentFundsDTOAdapter {
    static func adaptPLInvestimentFundsToInvestimentFunds(_ plInvestmentFunds: SANPLLibrary.InvestmentFundsDTO) -> SANLegacyLibrary.FundDTO {
        var fundDTO = SANLegacyLibrary.FundDTO()
        fundDTO.alias = plInvestmentFunds.name?.userDefined
        fundDTO.contractDescription = plInvestmentFunds.number
        let currencyDapter = CurrencyAdapter()
        fundDTO.currency = currencyDapter.adaptStringToCurrency(plInvestmentFunds.currentValue?.currencyCode)
        let amountAdapter = AmountAdapter()
        fundDTO.valueAmount = amountAdapter.adaptBalanceToAmount(plInvestmentFunds.currentValue)
        fundDTO.countervalueAmount = amountAdapter.adaptBalanceToCounterValueAmount(plInvestmentFunds.currentValue)
        fundDTO.contract = ContractDTO(bankCode: "", branchCode: "", product: "", contractNumber: plInvestmentFunds.accountId?.id)
        return fundDTO
    }
}

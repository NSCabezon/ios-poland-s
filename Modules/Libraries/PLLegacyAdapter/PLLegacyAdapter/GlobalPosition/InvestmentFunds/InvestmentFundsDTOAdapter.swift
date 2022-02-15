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
        fundDTO.valueAmount = AmountAdapter.adaptBalanceToAmount(plInvestmentFunds.currentValue)
        fundDTO.countervalueAmount = AmountAdapter.adaptBalanceToCounterValueAmount(plInvestmentFunds.currentValue)
        fundDTO.contract = ContractDTO(bankCode: "", branchCode: "", product: "", contractNumber: plInvestmentFunds.accountId?.id)
        fundDTO.accountId = SANLegacyLibrary.FundDTO.ProductId(id: plInvestmentFunds.accountId?.id, systemId: plInvestmentFunds.accountId?.systemId)
        fundDTO.productId = SANLegacyLibrary.FundDTO.ProductId(id: plInvestmentFunds.productId?.id, systemId: plInvestmentFunds.productId?.systemId)
        return fundDTO
    }
}

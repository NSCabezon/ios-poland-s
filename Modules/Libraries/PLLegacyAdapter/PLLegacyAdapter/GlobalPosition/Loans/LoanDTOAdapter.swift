//
//  LoanDTOAdapter.swift
//  PLLegacyAdapter
//

import SANPLLibrary
import SANLegacyLibrary

final class LoanDTOAdapter {
    static func adaptPLLoanToLoan(_ plLoan: SANPLLibrary.LoanDTO) -> SANLegacyLibrary.LoanDTO {
        var loanDTO = SANLegacyLibrary.LoanDTO()
        loanDTO.alias = plLoan.name?.userDefined
        let currencyAdapter = CurrencyAdapter()
        loanDTO.currency = currencyAdapter.adaptStringToCurrency(plLoan.currentLimit?.currencyCode)
        loanDTO.contractDescription = plLoan.number
        let amountAdapter = AmountAdapter()
        var amount = amountAdapter.adaptBalanceToAmount(plLoan.currentLimit)
        amount?.value?.negate()
        loanDTO.currentBalance = amount
        loanDTO.contract = ContractDTO(bankCode: nil, branchCode: nil, product: nil, contractNumber: plLoan.accountId?.id)
        return loanDTO
    }
}

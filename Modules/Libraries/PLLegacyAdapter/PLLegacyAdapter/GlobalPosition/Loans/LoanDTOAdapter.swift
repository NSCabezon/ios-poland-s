//
//  LoanDTOAdapter.swift
//  PLLegacyAdapter
//

import SANPLLibrary
import SANLegacyLibrary
import PLCommons

final class LoanDTOAdapter {
    static func adaptPLLoanToLoan(_ plLoan: SANPLLibrary.LoanDTO) -> SANLegacyLibrary.LoanDTO {
        var loanDTO = SANLegacyLibrary.LoanDTO()
        loanDTO.alias = plLoan.name?.userDefined
        let currencyAdapter = CurrencyAdapter()
        loanDTO.currency = currencyAdapter.adaptStringToCurrency(plLoan.currentLimit?.currencyCode)
        loanDTO.contractDescription = IBANFormatter.format(iban: plLoan.number)
        var amount = AmountAdapter.adaptBalanceToAmount(plLoan.currentLimit)
        amount?.value?.negate()
        loanDTO.currentBalance = amount
        var counterValueAmount = AmountAdapter.adaptBalanceToCounterValueAmount(plLoan.currentLimit)
        counterValueAmount?.value?.negate()
        loanDTO.counterValueCurrentBalanceAmount = counterValueAmount
        loanDTO.contract = ContractDTO(bankCode: "", branchCode: "", product: "", contractNumber: plLoan.accountId?.id)
        loanDTO.productId = .init(id: plLoan.accountId?.id, systemId: plLoan.accountId?.systemId)
        return loanDTO
    }
}

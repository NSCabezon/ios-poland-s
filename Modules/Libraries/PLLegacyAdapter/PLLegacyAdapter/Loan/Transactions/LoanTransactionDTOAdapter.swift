//
//  LoanTransactionDTOAdapter.swift
//  PLLegacyAdapter
//

import Foundation
import SANPLLibrary
import SANLegacyLibrary

final class LoanTransactionDTOAdapter {
    static func adaptPLLoanTransactionToLoanTransaction(_ plLoanTransaction: SANPLLibrary.LoanTransactionDTO) -> SANLegacyLibrary.LoanTransactionDTO {
        var loanTransactionDTO = SANLegacyLibrary.LoanTransactionDTO()
        loanTransactionDTO.description = "ASDASDASD"
        loanTransactionDTO.amount = AmountDTO(value: Decimal(plLoanTransaction.interestPayment ?? 0), currency: CurrencyDTO(currencyName: "PLN", currencyType: .other))
        loanTransactionDTO.operationDate = DateFormats.toDate(string: plLoanTransaction.paymentDate ?? "", output: .YYYYMMDD)
        // TODO: Agregar parámetros
        return loanTransactionDTO
    }
}

//
//  LoanTransactionDTOAdapter.swift
//  PLLegacyAdapter
//

import Foundation
import SANPLLibrary
import SANLegacyLibrary
import Commons

final class LoanTransactionDTOAdapter {
    static func adaptPLLoanTransactionToLoanTransaction(_ plLoanTransaction: SANPLLibrary.LoanOperationDTO) -> SANLegacyLibrary.LoanTransactionDTO {
        var loanTransactionDTO = SANLegacyLibrary.LoanTransactionDTO()
        loanTransactionDTO.description = plLoanTransaction.title
        let currencyDTO = CurrencyAdapter().adaptStringToCurrency(plLoanTransaction.extraData?.operationCurrency ?? "")
        if let currency = currencyDTO {
            loanTransactionDTO.amount = AmountDTO(value: Decimal(plLoanTransaction.interestAmount ?? 0), currency: currency)
        }
        loanTransactionDTO.operationDate = DateFormats.toDate(string: plLoanTransaction.valueDate ?? "", output: .YYYYMMDD)
        loanTransactionDTO.dgoNumber?.number = "\(plLoanTransaction.operationId?.postingDate ?? "")/\(plLoanTransaction.operationId?.operationLP ?? 0)"
        return loanTransactionDTO
    }
}

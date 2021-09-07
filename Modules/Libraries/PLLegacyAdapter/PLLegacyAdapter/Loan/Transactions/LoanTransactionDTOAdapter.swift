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
            let amount = Decimal(plLoanTransaction.amount ?? 0)
            let interestAmount = Decimal(plLoanTransaction.interestAmount ?? 0)
            let amountValue = amount + interestAmount
            loanTransactionDTO.amount = AmountDTO(value: amountValue, currency: currency)
        }
        loanTransactionDTO.operationDate = DateFormats.toDate(string: plLoanTransaction.valueDate ?? "", output: .YYYYMMDD)
        loanTransactionDTO.valueDate = DateFormats.toDate(string: plLoanTransaction.operationId?.postingDate ?? "", output: .YYYYMMDD)
        loanTransactionDTO.transactionNumber = "\(plLoanTransaction.operationId?.postingDate ?? "")/\(plLoanTransaction.operationId?.operationLP ?? 0)"
        return loanTransactionDTO
    }
}

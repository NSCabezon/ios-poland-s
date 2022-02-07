//
//  LoanTransactionDetailDTOAdapter.swift
//  PLLegacyAdapter
//

import Foundation
import SANPLLibrary
import SANLegacyLibrary
import CoreFoundationLib

final class LoanTransactionDetailDTOAdapter {
    static func adaptPLLoanTransactionToLoanTransactionDetail(_ plLoanTransaction: SANPLLibrary.LoanOperationDTO) -> SANLegacyLibrary.LoanTransactionDetailDTO {
        var loanTransactionDetailDTO = SANLegacyLibrary.LoanTransactionDetailDTO()
        let currencyCode = plLoanTransaction.extraData?.operationCurrency
        loanTransactionDetailDTO.capital = AmountAdapter.makeAmountDTO(value: plLoanTransaction.amount, currencyCode: currencyCode)
        loanTransactionDetailDTO.interestAmount = AmountAdapter.makeAmountDTO(value: plLoanTransaction.interestAmount, currencyCode: currencyCode)
        loanTransactionDetailDTO.recipientAccountNumber = plLoanTransaction.extraData?.sideCredit?.accountNo
        loanTransactionDetailDTO.recipientData = plLoanTransaction.extraData?.sideCredit?.address
        return loanTransactionDetailDTO
    }
}

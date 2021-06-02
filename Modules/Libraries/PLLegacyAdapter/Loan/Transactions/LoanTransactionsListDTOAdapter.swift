//
//  LoanTransactionsListDTOAdapter.swift
//  PLLegacyAdapter
//

import Foundation
import SANPLLibrary
import SANLegacyLibrary

final class LoanTransactionsListDTOAdapter {
    static func adaptPLLoanTransactionListToLoanTransactionList(_ plLoanTransactionList: SANPLLibrary.LoanTransactionsListDTO) -> SANLegacyLibrary.LoanTransactionsListDTO {
        var loanTransactionsListDTO = SANLegacyLibrary.LoanTransactionsListDTO()
        loanTransactionsListDTO.transactionDTOs = plLoanTransactionList.installments?.compactMap({
            LoanTransactionDTOAdapter.adaptPLLoanTransactionToLoanTransaction($0)
        }) ?? []
        return loanTransactionsListDTO
    }
}

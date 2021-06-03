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
        if let pagination = plLoanTransactionList.page?.first {
            loanTransactionsListDTO.pagination = LoanPaginationDTOAdapter.adaptPLLoanPaginationToLoanPagination(pagination)
        }
        return loanTransactionsListDTO
    }
}

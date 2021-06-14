//
//  LoanTransactionsListDTOAdapter.swift
//  PLLegacyAdapter
//

import Foundation
import SANPLLibrary
import SANLegacyLibrary

final class LoanTransactionsListDTOAdapter {
    static func adaptPLLoanTransactionListToLoanTransactionList(_ plLoanTransactionList: SANPLLibrary.LoanOperationListDTO) -> SANLegacyLibrary.LoanTransactionsListDTO {
        var loanTransactionsListDTO = SANLegacyLibrary.LoanTransactionsListDTO()
        loanTransactionsListDTO.transactionDTOs = plLoanTransactionList.operationList?.compactMap({
            LoanTransactionDTOAdapter.adaptPLLoanTransactionToLoanTransaction($0)
        }) ?? []
        let loanPagination = PaginationDTO(repositionXML: "", accountAmountXML: "", endList: true)
        loanTransactionsListDTO.pagination = loanPagination
        return loanTransactionsListDTO
    }
}

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
        // TODO: Agregar parámetros
        return loanTransactionDTO
    }
}

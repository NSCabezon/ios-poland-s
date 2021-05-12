//
//  PLLoansManagerAdapter.swift
//  PLLegacyAdapter
//
//  Created by Marcos Álvarez 11/05/2021
//

import SANLegacyLibrary

final class PLLoansManagerAdapter {}
 
extension PLLoansManagerAdapter: BSANLoansManager {
    func getLoanTransactions(forLoan loan: LoanDTO, dateFilter: DateFilter?, pagination: PaginationDTO?) throws -> BSANResponse<LoanTransactionsListDTO> {
        return BSANErrorResponse(nil)
    }
    
    func getLoanDetail(forLoan loan: LoanDTO) throws -> BSANResponse<LoanDetailDTO> {
        return BSANErrorResponse(nil)
    }
    
    func getLoanTransactionDetail(forLoan loan: LoanDTO, loanTransaction: LoanTransactionDTO) throws -> BSANResponse<LoanTransactionDetailDTO> {
        return BSANErrorResponse(nil)
    }
    
    func removeLoanDetail(loanDTO: LoanDTO) throws -> BSANResponse<Void> {
        return BSANErrorResponse(nil)
    }
    
    func confirmChangeAccount(loanDTO: LoanDTO, accountDTO: AccountDTO, signatureDTO: SignatureDTO) throws -> BSANResponse<Void> {
        return BSANErrorResponse(nil)
    }
    
    func getLoanPartialAmortization(loanDTO: LoanDTO) throws -> BSANResponse<LoanPartialAmortizationDTO> {
        return BSANErrorResponse(nil)
    }
    
    func validatePartialAmortization(loanPartialAmortizationDTO: LoanPartialAmortizationDTO, amount: AmountDTO, amortizationType: PartialAmortizationType) throws -> BSANResponse<LoanValidationDTO> {
        return BSANErrorResponse(nil)
    }
    
    func confirmPartialAmortization(loanPartialAmortizationDTO: LoanPartialAmortizationDTO, amount: AmountDTO, amortizationType: PartialAmortizationType, loanValidationDTO: LoanValidationDTO, signatureDTO: SignatureDTO) throws -> BSANResponse<Void> {
        return BSANErrorResponse(nil)
    }
    
    func changeLoanAlias(_ loan: LoanDTO, newAlias: String) throws -> BSANResponse<Void> {
        return BSANErrorResponse(nil)
    }
}

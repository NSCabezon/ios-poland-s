//
//  PLLoansManagerAdapter.swift
//  PLLegacyAdapter
//
//  Created by Marcos Álvarez 11/05/2021
//

import SANLegacyLibrary
import SANPLLibrary
import Commons

final class PLLoansManagerAdapter {

    private let loanManager: PLLoanManagerProtocol
    private let bsanDataProvider: BSANDataProvider

    init(loanManager: PLLoanManagerProtocol, bsanDataProvider: BSANDataProvider) {
        self.bsanDataProvider = bsanDataProvider
        self.loanManager = loanManager
    }
}
 
extension PLLoansManagerAdapter: BSANLoansManager {
    func getLoanTransactions(forLoan loan: SANLegacyLibrary.LoanDTO, dateFilter: DateFilter?, pagination: PaginationDTO?) throws -> BSANResponse<SANLegacyLibrary.LoanTransactionsListDTO> {
        guard let accountNumber = loan.contractDescription else {
            return BSANErrorResponse(nil)
        }

        let loanTransactionsParameters = LoanTransactionParameters(dateFrom: nil, dateTo: nil, operationCount: nil, getDirection: nil)
        let loanTransactionsList = try self.loanManager.getTransactions(withAccountNumber: accountNumber, parameters: loanTransactionsParameters).get()

        let adaptedLoanTransactionsList = LoanTransactionsListDTOAdapter.adaptPLLoanTransactionListToLoanTransactionList(loanTransactionsList)
        return BSANOkResponse(adaptedLoanTransactionsList)
    }
    
    func getLoanDetail(forLoan loan: SANLegacyLibrary.LoanDTO) throws -> BSANResponse<SANLegacyLibrary.LoanDetailDTO> {
        guard let accountNumber = loan.contractDescription else {
            return BSANErrorResponse(nil)
        }

        let loanDetailsParameters = LoanDetailsParameters(includeDetails: true, includePermissions: true, includeFunctionalities: true)
        let loanDetails = try self.loanManager.getDetails(accountNumber: accountNumber, parameters: loanDetailsParameters).get()

        let adaptedLoanDetail = LoanDetailsDTOAdapter.adaptPLLoanDetailsToLoanDetails(loanDetails)
        return BSANOkResponse(adaptedLoanDetail)
    }
    
    func getLoanTransactionDetail(forLoan loan: SANLegacyLibrary.LoanDTO, loanTransaction: SANLegacyLibrary.LoanTransactionDTO) throws -> BSANResponse<LoanTransactionDetailDTO> {
        return BSANErrorResponse(nil)
    }
    
    func removeLoanDetail(loanDTO: SANLegacyLibrary.LoanDTO) throws -> BSANResponse<Void> {
        return BSANErrorResponse(nil)
    }
    
    func confirmChangeAccount(loanDTO: SANLegacyLibrary.LoanDTO, accountDTO: SANLegacyLibrary.AccountDTO, signatureDTO: SignatureDTO) throws -> BSANResponse<Void> {
        return BSANErrorResponse(nil)
    }
    
    func getLoanPartialAmortization(loanDTO: SANLegacyLibrary.LoanDTO) throws -> BSANResponse<LoanPartialAmortizationDTO> {
        return BSANErrorResponse(nil)
    }
    
    func validatePartialAmortization(loanPartialAmortizationDTO: LoanPartialAmortizationDTO, amount: AmountDTO, amortizationType: PartialAmortizationType) throws -> BSANResponse<LoanValidationDTO> {
        return BSANErrorResponse(nil)
    }
    
    func confirmPartialAmortization(loanPartialAmortizationDTO: LoanPartialAmortizationDTO, amount: AmountDTO, amortizationType: PartialAmortizationType, loanValidationDTO: LoanValidationDTO, signatureDTO: SignatureDTO) throws -> BSANResponse<Void> {
        return BSANErrorResponse(nil)
    }
    
    func changeLoanAlias(_ loan: SANLegacyLibrary.LoanDTO, newAlias: String) throws -> BSANResponse<Void> {
        return BSANErrorResponse(nil)
    }
}

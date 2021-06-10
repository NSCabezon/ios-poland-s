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
        guard let accountId = loan.contractDescription else {
            return BSANErrorResponse(nil)
        }

        var dateFrom: String? = nil
        var dateTo: String? = nil
        if let dateFilterFrom = dateFilter?.fromDateModel?.date, let dateFilterTo = dateFilter?.toDateModel?.date {
            dateFrom = DateFormats.toString(date: dateFilterFrom, output: .YYYYMMDD)
            dateTo = DateFormats.toString(date: dateFilterTo, output: .YYYYMMDD)
        }

        let loanTransactionsParameters = LoanTransactionParameters(dateFrom: dateFrom, dateTo: dateTo, operationCount: nil, getDirection: nil)
        let loanTransactionsList = try self.loanManager.getTransactions(accountId: accountId, parameters: loanTransactionsParameters)

        let adaptedLoanTransactionsList = LoanTransactionsListDTOAdapter.adaptPLLoanTransactionListToLoanTransactionList(try loanTransactionsList.get())
        return BSANOkResponse(adaptedLoanTransactionsList)
    }
    
    func getLoanDetail(forLoan loan: SANLegacyLibrary.LoanDTO) throws -> BSANResponse<SANLegacyLibrary.LoanDetailDTO> {
        guard let accountId = loan.contractDescription else {
            return BSANErrorResponse(nil)
        }
        let loanDetails = try self.loanManager.getDetails(accountId: accountId)

        let adaptedLoanDetail = LoanDetailsDTOAdapter.adaptPLLoanDetailsToLoanDetails(try loanDetails.get(), loan: loan)
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

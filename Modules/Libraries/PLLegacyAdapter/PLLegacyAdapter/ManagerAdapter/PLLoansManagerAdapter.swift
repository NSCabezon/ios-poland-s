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
        BSANErrorResponse(nil)
    }
    
    func getLoanDetail(forLoan loan: SANLegacyLibrary.LoanDTO) throws -> BSANResponse<SANLegacyLibrary.LoanDetailDTO> {
        guard let accountNumber = loan.contractDescription?.replace(" ", "") else {
            return BSANErrorResponse(nil)
        }

        let loanDetailsParameters = LoanDetailsParameters(includeDetails: true, includePermissions: true, includeFunctionalities: true)
        let loanDetails = try self.loanManager.getDetails(accountNumber: accountNumber, parameters: loanDetailsParameters).get()
        let loanInstallments = try self.loanManager.getInstallments(accountId: loanDetails.id!, parameters: nil).get()

        let adaptedLoanDetail = LoanDetailsDTOAdapter.adaptPLLoanDetailsToLoanDetails(loanDetails, plLoanInstallments: loanInstallments)
        return BSANOkResponse(adaptedLoanDetail)
    }
    
    func getLoanTransactionDetail(forLoan loan: SANLegacyLibrary.LoanDTO, loanTransaction: SANLegacyLibrary.LoanTransactionDTO) throws -> BSANResponse<LoanTransactionDetailDTO> {
        guard let accountNumber = loan.contractDescription?.replace(" ", ""),
              let loanOperationList = self.bsanDataProvider.getLoanOperationList(withLoanId: accountNumber)?.operationList,
              let loanOperation = loanOperationList.first(where: { loanTransaction.transactionNumber == "\($0.operationId?.postingDate ?? "")/\($0.operationId?.operationLP ?? 0)" }) else {
            return BSANErrorResponse(nil)
        }

        let adaptedLoanTransactionDetail = LoanTransactionDetailDTOAdapter.adaptPLLoanTransactionToLoanTransactionDetail(loanOperation)
        return BSANOkResponse(adaptedLoanTransactionDetail)
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

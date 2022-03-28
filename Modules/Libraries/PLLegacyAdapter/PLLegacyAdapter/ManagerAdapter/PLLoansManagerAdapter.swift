//
//  PLLoansManagerAdapter.swift
//  PLLegacyAdapter
//
//  Created by Marcos Álvarez 11/05/2021
//

import SANLegacyLibrary
import SANPLLibrary
import CoreDomain
import CoreFoundationLib

final class PLLoansManagerAdapter {

    private let bsanDataProvider: BSANDataProvider
    private let loanManager: PLLoanManagerProtocol
    
    init(loanManager: PLLoanManagerProtocol, bsanDataProvider: BSANDataProvider) {
        self.bsanDataProvider = bsanDataProvider
        self.loanManager = loanManager
    }
}

extension PLLoansManagerAdapter: PLLoansManagerAdapterProtocol {
    func getLoanTransactionDetail(contractDescription: String?, transactionNumber: String?) throws -> BSANResponse<LoanTransactionDetailDTO> {
        guard let accountNumber = contractDescription?.replace(" ", ""),
              let loanOperationList = self.bsanDataProvider.getLoanOperationList(withLoanId: accountNumber)?.operationList,
              let loanOperation = loanOperationList.first(where: { transactionNumber == "\($0.operationId?.postingDate ?? "")/\($0.operationId?.operationLP ?? 0)" }) else {
            return BSANErrorResponse(nil)
        }

        let adaptedLoanTransactionDetail = LoanTransactionDetailDTOAdapter.adaptPLLoanTransactionToLoanTransactionDetail(loanOperation)
        return BSANOkResponse(adaptedLoanTransactionDetail)
    }
}

extension PLLoansManagerAdapter: BSANLoansManager {

    func getLoanTransactions(forLoan loan: SANLegacyLibrary.LoanDTO, dateFilter: DateFilter?, pagination: PaginationDTO?) throws -> BSANResponse<SANLegacyLibrary.LoanTransactionsListDTO> {
        BSANErrorResponse(nil)
    }
    
    func getLoanDetail(forLoan loan: SANLegacyLibrary.LoanDTO) throws -> BSANResponse<SANLegacyLibrary.LoanDetailDTO> {
        return BSANErrorResponse(nil)
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
		let result = try? loanManager.changeAlias(loanDTO: loan, newAlias: newAlias)
		
		switch result {
		case .success: return BSANOkResponse(nil)
		default: return BSANErrorResponse(nil)
		}
    }
}

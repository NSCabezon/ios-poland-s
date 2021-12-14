//
//  LoanDetailsDTOAdapter.swift
//  PLLegacyAdapter
//

import Foundation
import SANPLLibrary
import SANLegacyLibrary
import Commons

final class LoanDetailsDTOAdapter {
    static func adaptPLLoanDetailsToLoanDetails(_ plLoanDetails: SANPLLibrary.LoanDetailDTO, plLoanInstallments: SANPLLibrary.LoanInstallmentsListDTO?) -> SANLegacyLibrary.LoanDetailDTO {
        var loanDetailDTO = SANLegacyLibrary.LoanDetailDTO()
        loanDetailDTO.openingDate = DateFormats.toDate(string: plLoanDetails.accountDetails?.openedDate ?? "", output: .YYYYMMDD)
        let interestType = String(plLoanDetails.accountDetails?.interestRate ?? 0) + "%"
        loanDetailDTO.interestType = interestType.replacingOccurrences(of: ".", with: ",", options: .literal, range: nil)
        loanDetailDTO.initialAmount = AmountAdapter.adaptBalanceToAmount(plLoanDetails.loanAccountDetails?.grantedCreditLimit)
        loanDetailDTO.nextInstallmentDate = DateFormats.toDate(string: plLoanDetails.loanAccountDetails?.nextInstallmentDate ?? "", output: .YYYYMMDD)
        loanDetailDTO.currentDueDate = DateFormats.toDate(string: plLoanDetails.loanAccountDetails?.finalRepaymentDate ?? "", output: .YYYYMMDD)
        if let currentInterestAmount = plLoanDetails.loanAccountDetails?.interest?.previousTotalAmount?.value {
            let currentInterestAmountSt = "\(currentInterestAmount)" + " " + (plLoanDetails.loanAccountDetails?.grantedCreditLimit?.currencyCode ?? "")
            loanDetailDTO.currentInterestAmount = currentInterestAmountSt.replacingOccurrences(of: ".", with: ",", options: .literal, range: nil)
        }
        
        loanDetailDTO.lastOperationDate = DateFormats.toDate(string: plLoanDetails.lastUpdate ?? "", output: .YYYYMMDD)
        return loanDetailDTO
    }
}

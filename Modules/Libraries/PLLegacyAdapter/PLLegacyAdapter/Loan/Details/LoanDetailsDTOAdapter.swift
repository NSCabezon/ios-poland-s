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
        let interestType = String(plLoanDetails.loanAccountDetails?.interest?.rate ?? 0) + "%"
        loanDetailDTO.interestType = interestType.replacingOccurrences(of: ".", with: ",", options: .literal, range: nil)
        loanDetailDTO.initialAmount = AmountAdapter.adaptBalanceToAmount(plLoanDetails.loanAccountDetails?.grantedCreditLimit)
        loanDetailDTO.nextInstallmentDate = DateFormats.toDate(string: plLoanDetails.loanAccountDetails?.nextInstallmentDate ?? "", output: .YYYYMMDD)
        loanDetailDTO.currentDueDate = DateFormats.toDate(string: plLoanDetails.loanAccountDetails?.finalRepaymentDate ?? "", output: .YYYYMMDD)
        if let currentInterestAmount = plLoanInstallments?.installments?.last?.totalPayment {
            loanDetailDTO.currentInterestAmount = "\(currentInterestAmount)"
        }

        return loanDetailDTO
    }
}

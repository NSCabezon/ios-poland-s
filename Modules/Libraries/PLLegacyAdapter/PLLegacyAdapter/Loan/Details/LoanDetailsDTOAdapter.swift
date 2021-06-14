//
//  LoanDetailsDTOAdapter.swift
//  PLLegacyAdapter
//

import Foundation
import SANPLLibrary
import SANLegacyLibrary
import Commons

final class LoanDetailsDTOAdapter {
    static func adaptPLLoanDetailsToLoanDetails(_ plLoanDetails: SANPLLibrary.LoanDetailDTO, loan: SANLegacyLibrary.LoanDTO) -> SANLegacyLibrary.LoanDetailDTO {
        var loanDetailDTO = SANLegacyLibrary.LoanDetailDTO()
        loanDetailDTO.openingDate = DateFormats.toDate(string: plLoanDetails.accountDetails?.openedDate ?? "", output: .YYYYMMDD)
        loanDetailDTO.initialDueDate = DateFormats.toDate(string: plLoanDetails.loanAccountDetails?.finalRepaymentDate ?? "", output: .YYYYMMDD)
        loanDetailDTO.interestTypeDesc = plLoanDetails.loanAccountDetails?.interest?.rateName
        loanDetailDTO.interestType = Decimal(plLoanDetails.loanAccountDetails?.interest?.rate ?? 0)

        if let currencyDTO = CurrencyAdapter().adaptStringToCurrency(plLoanDetails.balance?.currencyCode),
           let balance = plLoanDetails.balance?.value,
           let totalPaid = plLoanDetails.loanAccountDetails?.interest?.totalPaid?.value {
            let initialAmount = AmountDTO(value: Decimal(balance - totalPaid), currency: currencyDTO)
            loanDetailDTO.initialAmount = initialAmount
        }

        return loanDetailDTO
    }
}

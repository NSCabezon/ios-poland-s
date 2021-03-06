//
//  AccountDetailsDTOAdapter.swift
//  PLLegacyAdapter
//

import Foundation
import SANPLLibrary
import SANLegacyLibrary
import CoreFoundationLib

final class AccountDetailsDTOAdapter {
    static func adaptPLAccountDetailsToAccountDetails(_ plAccountDetail: SANPLLibrary.AccountDetailDTO, account: SANPLLibrary.AccountDTO, swiftBranches: SwiftBranchesDTO?) -> SANLegacyLibrary.AccountDetailDTO {
        var accountDetailDTO = SANLegacyLibrary.AccountDetailDTO()
        accountDetailDTO.holder = nil
        accountDetailDTO.iban = IBANDTO(ibanString: plAccountDetail.number ?? "")
        accountDetailDTO.balance = AmountAdapter.adaptBalanceToAmount(plAccountDetail.balance)
        accountDetailDTO.availableAmount = AmountAdapter.adaptBalanceToAmount(plAccountDetail.availableFunds)
        accountDetailDTO.productName = plAccountDetail.name?.description
        accountDetailDTO.overdraftAmount = AmountAdapter.adaptBalanceToAmount(account.overDraftLimit)
        accountDetailDTO.withholdingAmount = AmountAdapter.adaptBalanceToAmount(account.withholdingBalance)
        accountDetailDTO.interestRate = PercentAdapter.adaptValueToPercentPresentation(plAccountDetail.accountDetails?.interestRate)
        return accountDetailDTO
    }
    
    static func adaptPLWithholdingListToWithholdingList(withholdingList: SANPLLibrary.WithholdingListDTO) -> SANLegacyLibrary.WithholdingListDTO {
        
        var legacyWithholdingDTOList: [SANLegacyLibrary.WithholdingDTO] = []
        
        for element in withholdingList.withholdingDTO {
            
            let sourceDate = DateFormats.toDate(string: element.sourceDate ?? "", output: DateFormats.TimeFormat.YYYYMMDD)
            let operTime = DateFormats.toDate(string: element.operTime ?? "", output: DateFormats.TimeFormat.YYYYMMDD_HHmmss)

            var newAmount = element.amount ?? 0.0
            if element.isDebit() {
                newAmount.negate()
            }
            
            let newLegacyWithholding = SANLegacyLibrary.WithholdingDTO(entryDate: sourceDate ?? Date(), leavingDate: operTime ?? Date(), concept: element.transTitle ?? "", amount: newAmount)
           
            legacyWithholdingDTOList.append(newLegacyWithholding)
        }
        return SANLegacyLibrary.WithholdingListDTO(withholdingDTO: legacyWithholdingDTOList)
    }
}

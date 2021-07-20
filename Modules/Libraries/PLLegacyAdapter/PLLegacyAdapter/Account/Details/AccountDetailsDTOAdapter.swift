//
//  AccountDetailsDTOAdapter.swift
//  PLLegacyAdapter
//

import Foundation
import SANPLLibrary
import SANLegacyLibrary
import Commons

final class AccountDetailsDTOAdapter {
    static func adaptPLAccountDetailsToAccountDetails(_ plAccountDetail: SANPLLibrary.AccountDetailDTO, account: SANPLLibrary.AccountDTO, swiftBranches: SwiftBranchesDTO?) -> SANLegacyLibrary.AccountDetailDTO {
        var accountDetailDTO = SANLegacyLibrary.AccountDetailDTO()
        accountDetailDTO.holder = ""
        accountDetailDTO.iban = IBANDTO(ibanString: plAccountDetail.number ?? "")
        accountDetailDTO.balance = AmountAdapter.adaptBalanceToAmount(plAccountDetail.balance)
        accountDetailDTO.availableAmount = AmountAdapter.adaptBalanceToAmount(plAccountDetail.availableFunds)
        accountDetailDTO.productName = plAccountDetail.name?.description
        accountDetailDTO.overdraftAmount = AmountAdapter.adaptBalanceToAmount(plAccountDetail.accountDetails?.overDraftLimit)
        accountDetailDTO.withholdingAmount = AmountAdapter.adaptBalanceToAmount(account.withholdingBalance)
        accountDetailDTO.bicCode = swiftBranches?.swiftBranchList?.first?.bic

        return accountDetailDTO
    }
}

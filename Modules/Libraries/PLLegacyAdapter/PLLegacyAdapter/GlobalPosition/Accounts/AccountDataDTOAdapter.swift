//
//  AccountDataDTOAdapter.swift
//  PortugalLegacyAdapter
//

import Foundation
import SANPLLibrary
import SANLegacyLibrary

final class AccountDataDTOAdapter {
    func adaptPLAccountToAccountDetail(_ plAccount: SANPLLibrary.AccountDTO) -> SANLegacyLibrary.AccountDetailDTO {
        var accountDataDTO = SANLegacyLibrary.AccountDetailDTO()
        accountDataDTO.mainItem = plAccount.defaultForPayments
        accountDataDTO.description = plAccount.name?.description
        accountDataDTO.accountId = plAccount.accountId?.id

        let amountAdapter = AmountAdapter()
        accountDataDTO.mainBalance = amountAdapter.adaptBalanceToAmount(plAccount.balance)
        accountDataDTO.withholdingAmount = amountAdapter.adaptBalanceToAmount(plAccount.withholdingBalance)

        return accountDataDTO
    }
}

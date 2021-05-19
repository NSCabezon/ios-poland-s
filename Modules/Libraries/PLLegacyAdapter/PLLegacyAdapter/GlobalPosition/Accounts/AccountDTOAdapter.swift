//
//  AccountDTOAdapter.swift
//  PLLegacyAdapter
//

import SANPLLibrary
import SANLegacyLibrary

public final class AccountDTOAdapter {
    public func adaptPLAccountToAccount(_ plAccount: SANPLLibrary.AccountDTO) -> SANLegacyLibrary.AccountDTO {
        var accountDTO = SANLegacyLibrary.AccountDTO()
        accountDTO.alias = plAccount.name?.userDefined
        accountDTO.iban = IBANDTOAdapter.adaptDisplayNumberToIBAN(plAccount.number)

        let amountAdapter = AmountAdapter()
        accountDTO.currentBalance = amountAdapter.adaptBalanceToAmount(plAccount.balance)
        accountDTO.availableAutAmount = amountAdapter.adaptBalanceToAmount(plAccount.availableFunds)

        return accountDTO
    }

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

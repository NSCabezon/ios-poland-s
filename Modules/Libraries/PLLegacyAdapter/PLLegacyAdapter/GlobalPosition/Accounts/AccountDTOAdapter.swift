//
//  AccountDTOAdapter.swift
//  PortugalLegacyAdapter
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
}

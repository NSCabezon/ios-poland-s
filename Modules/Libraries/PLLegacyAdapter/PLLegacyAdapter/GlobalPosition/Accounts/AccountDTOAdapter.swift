//
//  AccountDTOAdapter.swift
//  PLLegacyAdapter
//

import SANPLLibrary
import SANLegacyLibrary

public final class AccountDTOAdapter {
    
    static func adaptPLAccountToAccount(_ plAccount: SANPLLibrary.AccountDTO) -> SANLegacyLibrary.AccountDTO {
        var accountDTO = SANLegacyLibrary.AccountDTO()
        accountDTO.alias = plAccount.name?.userDefined
        accountDTO.tipoSituacionCto = plAccount.type
        accountDTO.iban = IBANDTOAdapter.adaptDisplayNumberToIBAN(plAccount.number)

        let amountAdapter = AmountAdapter()
        accountDTO.currentBalance = amountAdapter.adaptBalanceToAmount(plAccount.balance)
        accountDTO.availableNoAutAmount = amountAdapter.adaptBalanceToAmount(plAccount.availableFunds)

        accountDTO.contract = ContractDTO(bankCode: nil, branchCode: nil, product: nil, contractNumber: plAccount.accountId?.id)

        return accountDTO
    }

    static func adaptPLAccountToAccountDetail(_ plAccount: SANPLLibrary.AccountDTO) -> SANLegacyLibrary.AccountDetailDTO {
        var accountDetailDTO = SANLegacyLibrary.AccountDetailDTO()
        accountDetailDTO.mainItem = plAccount.defaultForPayments
        accountDetailDTO.description = plAccount.name?.description
        accountDetailDTO.accountId = plAccount.accountId?.id

        let amountAdapter = AmountAdapter()
        accountDetailDTO.mainBalance = amountAdapter.adaptBalanceToAmount(plAccount.balance)
        accountDetailDTO.withholdingAmount = amountAdapter.adaptBalanceToAmount(plAccount.withholdingBalance)

        return accountDetailDTO
    }
}

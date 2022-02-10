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
        accountDTO.contractDescription = plAccount.number
        accountDTO.tipoSituacionCto = plAccount.type
        accountDTO.iban = IBANDTOAdapter.adaptDisplayNumberToIBAN(plAccount.number)
        accountDTO.currentBalance = AmountAdapter.adaptBalanceToAmount(plAccount.balance)
        accountDTO.countervalueCurrentBalanceAmount = AmountAdapter.adaptBalanceToCounterValueAmount(plAccount.balance)
        accountDTO.availableNoAutAmount = AmountAdapter.adaptBalanceToAmount(plAccount.availableFunds)
        accountDTO.countervalueAvailableNoAutAmount = AmountAdapter.adaptBalanceToCounterValueAmount(plAccount.availableFunds)
        
        if plAccount.productId != nil {
            accountDTO.productId = SANLegacyLibrary.AccountDTO.ProductID(id: plAccount.productId?.id, systemId: plAccount.productId?.systemId ?? nil)
        }
        
        accountDTO.contract = ContractDTO(bankCode: "", branchCode: "", product: "", contractNumber: plAccount.number)
        accountDTO.isMainAccount = plAccount.defaultForPayments

        return accountDTO
    }

    static func adaptPLAccountToAccountDetail(_ plAccount: SANPLLibrary.AccountDTO) -> SANLegacyLibrary.AccountDetailDTO {
        var accountDetailDTO = SANLegacyLibrary.AccountDetailDTO()
        accountDetailDTO.mainItem = plAccount.defaultForPayments
        accountDetailDTO.description = plAccount.name?.description
        accountDetailDTO.accountId = plAccount.accountId?.id
        accountDetailDTO.mainBalance = AmountAdapter.adaptBalanceToAmount(plAccount.balance)
        accountDetailDTO.withholdingAmount = AmountAdapter.adaptBalanceToAmount(plAccount.withholdingBalance)

        return accountDetailDTO
    }
}

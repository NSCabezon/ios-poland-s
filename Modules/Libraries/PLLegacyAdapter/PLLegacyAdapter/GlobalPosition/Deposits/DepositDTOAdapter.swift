//
//  DepositDTOAdapter.swift
//  PLLegacyAdapter
//
//  Created by Rodrigo Jurado on 20/5/21.
//

import SANLegacyLibrary
import SANPLLibrary


final class DepositDTOAdapter {
    static func adaptPLDepositToDeposit(_ plDeposit: SANPLLibrary.DepositDTO) -> SANLegacyLibrary.DepositDTO {
        var depositDTO = SANLegacyLibrary.DepositDTO()
        depositDTO.alias = plDeposit.name?.userDefined
        let currencyAdapter = CurrencyAdapter()
        depositDTO.currency = currencyAdapter.adaptStringToCurrency(plDeposit.currentBalance?.currencyCode)
        depositDTO.contractDescription = plDeposit.number
        depositDTO.balance = AmountAdapter.adaptBalanceToAmount(plDeposit.currentBalance)
        depositDTO.countervalueCurrentBalance = AmountAdapter.adaptBalanceToCounterValueAmount(plDeposit.currentBalance)
        depositDTO.contract = ContractDTO(bankCode: "", branchCode: "", product: "", contractNumber: plDeposit.accountId?.id)
        depositDTO.accountId = SANLegacyLibrary.DepositDTO.ProductID(id: plDeposit.accountId?.id, systemId: plDeposit.accountId?.systemId)
        return depositDTO
    }
}

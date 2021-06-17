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
        let amountAdapter = AmountAdapter()
        depositDTO.balance = amountAdapter.adaptBalanceToAmount(plDeposit.currentBalance)
        depositDTO.countervalueCurrentBalance = amountAdapter.adaptBalanceToCounterValueAmount(plDeposit.currentBalance)
        depositDTO.contract = ContractDTO(bankCode: "", branchCode: "", product: "", contractNumber: plDeposit.accountId?.id)
        return depositDTO
    }
}

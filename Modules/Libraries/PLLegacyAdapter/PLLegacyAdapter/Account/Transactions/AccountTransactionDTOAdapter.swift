//
//  AccountTransactionDTOAdapter.swift
//  PLLegacyAdapter
//
//  Created by Rodrigo Jurado on 23/7/21.
//

import SANPLLibrary
import SANLegacyLibrary

public final class AccountTransactionDTOAdapter {
    public static func adaptPLAccountTransactionToAccountTransaction(_ plAccountTransaction: SANPLLibrary.AccountTransactionDTO) -> SANLegacyLibrary.AccountTransactionDTO {
        var accountTransactionDTO = SANLegacyLibrary.AccountTransactionDTO()
        accountTransactionDTO.operationDate = plAccountTransaction.sourceDate?.getDate(withFormat: "yyyy-MM-dd")
        accountTransactionDTO.valueDate = plAccountTransaction.postedDate?.getDate(withFormat: "yyyy-MM-dd")
        accountTransactionDTO.transactionNumber = String(plAccountTransaction.lp ?? 0)
        let transactionCurrency = plAccountTransaction.currency ?? plAccountTransaction.currencyCodeDt
        var amount = AmountAdapter.makeAmountDTO(value: plAccountTransaction.amount, currencyCode: transactionCurrency)
        if plAccountTransaction.debitFlag?.lowercased() == "debit" {
            amount?.value?.negate()
        }
        accountTransactionDTO.amount = amount
        accountTransactionDTO.balance = AmountAdapter.makeAmountDTO(value: plAccountTransaction.balance, currencyCode: transactionCurrency)
        accountTransactionDTO.description = plAccountTransaction.transTitle
        let isDebit = plAccountTransaction.debitFlag?.lowercased() == "debit"
        accountTransactionDTO.status = plAccountTransaction.state
        accountTransactionDTO.recipientData = isDebit ? plAccountTransaction.othCustName : plAccountTransaction.custName
        accountTransactionDTO.recipientAccountNumber = isDebit ? plAccountTransaction.othCustAccNo : plAccountTransaction.accountNumber
        accountTransactionDTO.senderData = isDebit ? plAccountTransaction.custName : plAccountTransaction.othCustName
        accountTransactionDTO.senderAccountNumber = isDebit ? plAccountTransaction.accountNumber : plAccountTransaction.othCustAccNo
        return accountTransactionDTO
    }
}

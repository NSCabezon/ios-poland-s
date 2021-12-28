//
//  AccountTransactionDTOAdapter.swift
//  PLLegacyAdapter
//
//  Created by Rodrigo Jurado on 23/7/21.
//

import SANPLLibrary
import SANLegacyLibrary
import CoreFoundationLib

public final class AccountTransactionDTOAdapter {
    public static func adaptPLAccountTransactionToAccountTransaction(_ plAccountTransaction: SANPLLibrary.AccountTransactionDTO, customer: SANPLLibrary.CustomerDTO?) -> SANLegacyLibrary.AccountTransactionDTO {
        var accountTransactionDTO = SANLegacyLibrary.AccountTransactionDTO()
        accountTransactionDTO.operationDate = DateFormats.toDate(string: plAccountTransaction.sourceDate ?? "", output: DateFormats.TimeFormat.YYYYMMDD)
        accountTransactionDTO.valueDate = DateFormats.toDate(string: plAccountTransaction.postedDate ?? "", output: DateFormats.TimeFormat.YYYYMMDD)
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
        let customerName = plAccountTransaction.custName?.capitalized ?? self.getOwnerData(from: customer)
        accountTransactionDTO.status = plAccountTransaction.state?.capitalized
        accountTransactionDTO.recipientData = isDebit ? plAccountTransaction.othCustName?.capitalized : customerName
        accountTransactionDTO.recipientAccountNumber = isDebit ? plAccountTransaction.othCustAccNo : plAccountTransaction.accountNumber
        accountTransactionDTO.senderData = isDebit ? customerName : plAccountTransaction.othCustName?.capitalized
        accountTransactionDTO.senderAccountNumber = isDebit ? plAccountTransaction.accountNumber : plAccountTransaction.othCustAccNo
        return accountTransactionDTO
    }

    private static func getOwnerData(from customer: SANPLLibrary.CustomerDTO?) -> String {
        guard let customer = customer else { return "" }
        let name = customer.address?.name ?? ""
        let street = customer.address?.street ?? ""
        let propertyNo = customer.address?.propertyNo ?? ""
        let zip = customer.address?.zip ?? ""
        let city = customer.address?.city ?? ""
        return "\(name), \(street) \(propertyNo), \(zip) \(city)".camelCasedString
    }
}

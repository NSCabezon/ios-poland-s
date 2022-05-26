//
//  PLDomesticTransactionParametersProvider.swift
//  SANPLLibrary
//
//  Created by 187830 on 05/11/2021.
//
import CoreFoundationLib
import CoreDomain

public class PLDomesticTransactionParametersProvider: PLDomesticTransactionParametersGenerable {
    
    public init() {}
    
    public func getParameters(
        transactionParametersInput: PLDomesticTransactionParametersInput,
        type: PLDomesticTransactionParametersType
    ) -> String {
        let amountEntity = AmountEntity(
            value: transactionParametersInput.debitAmount,
            currencyCode: ""
        )
        var tmpDebitAmount = amountEntity.getFormattedValue()
        tmpDebitAmount = tmpDebitAmount.replacingOccurrences(of: ",", with: ".")
        tmpDebitAmount = tmpDebitAmount.replacingOccurrences(of: " ", with: "")
        if tmpDebitAmount.count < 13 {
            tmpDebitAmount = [
                String(repeating: "0", count: 13 - tmpDebitAmount.count),
                tmpDebitAmount
            ].joined()
        }
        if case .mCommerceBelow(_) = type {
            return [
                transactionParametersInput.creditAccountNumber,
                tmpDebitAmount,
                transactionParametersInput.userID
            ].joined()
        }
        if case .codeBlik(_) = type {
            var formatAmountTmp = PLAmountFormatter.formatAmount(
                amount: transactionParametersInput.debitAmount.getStringValue()
            )
            formatAmountTmp = formatAmountTmp?.replacingOccurrences(of: ",", with: ".")
            formatAmountTmp = formatAmountTmp?.replacingOccurrences(of: " ", with: "")
            return [
                transactionParametersInput.merchantId,
                formatAmountTmp ?? "",
                transactionParametersInput.transactionTime
            ].joined()
        }
        return [
            transactionParametersInput.debitAccountNumber,
            transactionParametersInput.creditAccountNumber,
            tmpDebitAmount,
            transactionParametersInput.userID
        ].joined()
    }
}

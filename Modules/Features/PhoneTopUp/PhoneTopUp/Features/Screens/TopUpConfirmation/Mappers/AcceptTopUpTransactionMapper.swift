//
//  AcceptTopUpTransactionMapper.swift
//  PhoneTopUp
//
//  Created by 188216 on 21/02/2022.
//

import Foundation
import CoreFoundationLib
import SANPLLibrary
import SANLegacyLibrary
import PLCommons

protocol AcceptTopUpTransactionInputMapping {
    func map(with input: PerformTopUpTransactionUseCaseInput) -> GenericSendMoneyConfirmationInput
}

final class AcceptTopUpTransactionInputMapper: AcceptTopUpTransactionInputMapping {
    // MARK: Properties
    
    private let blueMediaAccountNumber = "40109014890000000048087486"
    
    // MARK: Lifecycle
    
    func map(with input: PerformTopUpTransactionUseCaseInput) -> GenericSendMoneyConfirmationInput {
        let transferTitle = "Topping up a pre-paid telephone +48\(input.recipientNumber)"
        let transactionType = AcceptDomesticTransactionParameters.TransactionType.PREPAID_MOBILE_TRANSACTION
        let transferType: AcceptDomesticTransactionParameters.TransferType = .INTERNAL
        let debitAccountFormated = IBANFormatter.formatIbanToNrb(
            for: input.account.number
        )

        let creditAccountFormated = IBANFormatter.formatIbanToNrb(
            for: blueMediaAccountNumber
        )

        let amountData = ItAmountDataParameters(currency: CurrencyType.złoty.name,
                                                amount: Decimal(input.amount)
        )
        
        let debitAccounData = ItAccountDataParameters(accountNo: debitAccountFormated,
                                                      accountName: input.account.name,
                                                      accountSequenceNumber: input.account.accountSequenceNumber,
                                                      accountType: input.account.accountType
        )
        let creditAccountData = ItAccountDataParameters(accountNo: creditAccountFormated,
                                                        accountName: nil,
                                                        accountSequenceNumber: 0,
                                                        accountType: 70
        )
        
        return GenericSendMoneyConfirmationInput(
            customerAddressData: nil,
            debitAmountData: amountData,
            creditAmountData: amountData,
            debitAccountData: debitAccounData,
            creditAccountData: creditAccountData,
            signData: nil,
            title: transferTitle,
            type: transactionType.rawValue,
            transferType: transferType.rawValue,
            valueDate: nil)
    }
}

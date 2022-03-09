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
import PLCommonOperatives
import PLCommons

protocol PerformTopUpTransactionInputMapping {
    func mapSendMoneyConfirmationInput(with input: PerformTopUpTransactionUseCaseInput, userId: Int) -> GenericSendMoneyConfirmationInput
    func mapNotifyDeviceInput(with input: PerformTopUpTransactionUseCaseInput, challenge: String) -> NotifyDeviceInput
    func mapPartialNotifyDeviceInput(with input: PerformTopUpTransactionUseCaseInput) -> PartialNotifyDeviceInput
}

final class PerformTopUpTransactionInputMapper: PerformTopUpTransactionInputMapping {
    // MARK: Properties
    
    private let transactionParametersProvider: PLTransactionParametersProviderProtocol
    
    // MARK: Lifecycle
    
    init(dependenciesResolver: DependenciesResolver) {
        transactionParametersProvider = dependenciesResolver.resolve(for: PLTransactionParametersProviderProtocol.self)
    }
    
    // MARK: Methods
    
    func mapSendMoneyConfirmationInput(with input: PerformTopUpTransactionUseCaseInput, userId: Int) -> GenericSendMoneyConfirmationInput {
        let transferTitle = "Topping up a pre-paid telephone +48\(input.recipientNumber)"
        let transactionType = AcceptDomesticTransactionParameters.TransactionType.ONEAPP_PREPAID_MOBILE_TRANSACTION
        let transferType: AcceptDomesticTransactionParameters.TransferType = .INTERNAL
        let debitAccountFormated = IBANFormatter.formatIbanToNrb(
            for: input.sourceAccount.number
        )

        let creditAccountFormated = IBANFormatter.formatIbanToNrb(
            for: input.topUpAccount.number
        )

        let amountData = ItAmountDataParameters(currency: CurrencyType.złoty.name,
                                                amount: Decimal(input.amount)
        )
        
        let debitAccounData = ItAccountDataParameters(accountNo: debitAccountFormated,
                                                      accountName: input.sourceAccount.name,
                                                      accountSequenceNumber: input.sourceAccount.accountSequenceNumber,
                                                      accountType: input.sourceAccount.accountType
        )
        let creditAccountData = ItAccountDataParameters(accountNo: creditAccountFormated,
                                                        accountName: input.topUpAccount.name,
                                                        accountSequenceNumber: 0,
                                                        accountType: 70
        )
        
        let signData = SignDataParameters(securityLevel: 2048)
        let date = input.date.toString(format: TimeFormat.yyyyMMdd.rawValue)
        
        let transactionParametersInput = PLDomesticTransactionParametersInput(
            debitAccountNumber: debitAccountFormated,
            creditAccountNumber: creditAccountFormated,
            debitAmount: Decimal(input.amount),
            userID: String(describing: userId)
        )
        
        let transactionParameters = transactionParametersProvider.getTransactionParameters(
            type: .topUpTransfer(transactionParametersInput)
        )
        
        return GenericSendMoneyConfirmationInput(
            customerAddressData: nil,
            debitAmountData: amountData,
            creditAmountData: amountData,
            debitAccountData: debitAccounData,
            creditAccountData: creditAccountData,
            signData: signData,
            title: transferTitle,
            type: transactionType.rawValue,
            transferType: transferType.rawValue,
            valueDate: date,
            gsmNumber: input.recipientNumber,
            gsmOperatorId: input.operatorId,
            transactionParameters: transactionParameters)
    }
    
    func mapNotifyDeviceInput(with input: PerformTopUpTransactionUseCaseInput, challenge: String) -> NotifyDeviceInput {
        return NotifyDeviceInput(partialInput: mapPartialNotifyDeviceInput(with: input),
                                 challenge: challenge)
    }
    
    func mapPartialNotifyDeviceInput(with input: PerformTopUpTransactionUseCaseInput) -> PartialNotifyDeviceInput {
        let iban = IBANRepresented(ibanString: IBANFormatter.formatIbanToNrb(for: input.topUpAccount.number))
        let amount = AmountDTO(
            value: Decimal(input.amount),
            currency: CurrencyDTO(
                currencyName: CurrencyType.złoty.name,
                currencyType: .złoty
            )
        )
        
        return PartialNotifyDeviceInput(
            softwareTokenType: nil,
            notificationSchemaId: "165",
            alias: input.topUpAccount.name,
            iban: iban,
            amount: amount,
            variables: [input.recipientNumber, "\(input.amount)", CurrencyType.złoty.name]
        )
    }
}

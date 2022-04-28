//
//  TaxTransferSendMoneyInputMapper.swift
//  TaxTransfer
//
//  Created by 187831 on 03/04/2022.
//

import SANPLLibrary
import SANLegacyLibrary
import CoreFoundationLib
import PLCommons
import PLCommonOperatives

protocol TaxTransferSendMoneyInputMapping {
    func map(model: TaxTransferModel, userId: Int) -> GenericSendMoneyConfirmationInput
    func mapPartialNotifyDeviceInput(with model: TaxTransferModel) -> PartialNotifyDeviceInput
}

final class TaxTransferSendMoneyInputMapper: TaxTransferSendMoneyInputMapping {
    private typealias TransactionParameters = AcceptDomesticTransactionParameters
    private typealias TransactionType = TransactionParameters.TransactionType
    
    private struct Constants {
        static var accountType = 84
        static var accountSequenceNumber = 0
        static var securityLevel = 2048
        static var transferType: TransactionParameters.TransferType = .US
        static var transactionType: TransactionType = .ONEAPP_TAX_TRANSACTION
    }
    
    private let transactionParametersProvider: PLTransactionParametersProviderProtocol
    
    init(dependenciesResolver: DependenciesResolver) {
        transactionParametersProvider = dependenciesResolver.resolve(for: PLTransactionParametersProviderProtocol.self)
    }
    
    func map(model: TaxTransferModel, userId: Int) -> GenericSendMoneyConfirmationInput {
        let debitAccountFormated = IBANFormatter.formatIbanToNrb(
            for: model.account.number
         )
         let creditAccountFormated = IBANFormatter.formatIbanToNrb(
            for: model.recipientAccountNumber
         )
        let amountData = ItAmountDataParameters(
            currency: CurrencyType.złoty.name,
            amount: model.amount
        )
        let debitAccountData = ItAccountDataParameters(
            accountNo: debitAccountFormated,
            accountName: model.account.name,
            accountSequenceNumber: model.account.accountSequenceNumber,
            accountType: model.account.accountType
        )
        let creditAccountData = ItAccountDataParameters(
            accountNo: creditAccountFormated,
            accountName: model.recipientName,
            accountSequenceNumber: Constants.accountSequenceNumber,
            accountType: Constants.accountType
         )
        let signData = SignDataParameters(
            securityLevel: Constants.securityLevel
        )
        let transactionParametersInput = PLDomesticTransactionParametersInput(
            debitAccountNumber: debitAccountFormated,
            creditAccountNumber: creditAccountFormated,
            debitAmount: model.amount,
            userID: String(describing: userId)
        )
        let transactionParameters = transactionParametersProvider.getTransactionParameters(
            type: .taxTransfer(transactionParametersInput)
        )

        let date = model.date.toString(format: TimeFormat.yyyyMMdd.rawValue)
        
        return GenericSendMoneyConfirmationInput(
            customerAddressData: nil,
            debitAmountData: amountData,
            creditAmountData: amountData,
            debitAccountData: debitAccountData,
            creditAccountData: creditAccountData,
            signData: signData,
            title: model.title,
            type: Constants.transactionType.rawValue,
            transferType: Constants.transferType.rawValue,
            valueDate: date,
            transactionParameters: transactionParameters
        )
    }
    
    func mapPartialNotifyDeviceInput(with model: TaxTransferModel) -> PartialNotifyDeviceInput {
        let iban = IBANRepresented(ibanString: IBANFormatter.formatIbanToNrb(for: model.recipientAccountNumber))
        let amount = AmountDTO(
            value: model.amount,
            currency: CurrencyDTO(
                currencyName: CurrencyType.złoty.name,
                currencyType: .złoty
            )
        )
        let recipientName = model.recipientName ?? ""
        
        return PartialNotifyDeviceInput(
            softwareTokenType: nil,
            notificationSchemaId: "195",
            alias: "",
            iban: iban,
            amount: amount,
            variables: ["\(model.amount)",
                        CurrencyType.złoty.name,
                        model.recipientAccountNumber,
                        recipientName]
        )
    }
}

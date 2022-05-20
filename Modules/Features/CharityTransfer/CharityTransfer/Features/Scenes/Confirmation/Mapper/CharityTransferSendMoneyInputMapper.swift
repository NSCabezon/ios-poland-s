import Foundation
import CoreFoundationLib
import SANPLLibrary
import SANLegacyLibrary
import PLCommons
import PLCommonOperatives

protocol CharityTransferSendMoneyInputMapping {
    func map(with model: CharityTransferModel, userId: Int) -> GenericSendMoneyConfirmationInput
    func mapPartialNotifyDeviceInput(with model: CharityTransferModel) -> PartialNotifyDeviceInput
}

final class CharityTransferSendMoneyInputMapper: CharityTransferSendMoneyInputMapping {
    private let transactionParametersProvider: PLTransactionParametersProviderProtocol
    
    init(dependenciesResolver: DependenciesResolver) {
        transactionParametersProvider = dependenciesResolver.resolve(for: PLTransactionParametersProviderProtocol.self)
    }
    
    func map(with model: CharityTransferModel, userId: Int) -> GenericSendMoneyConfirmationInput {
        let debitAccountFormated = IBANFormatter.formatIbanToNrb(
            for: model.account.number
        )
        let creditAccountFormated = IBANFormatter.formatIbanToNrb(
            for: model.recipientAccountNumber
        )
        
        let amountData = ItAmountDataParameters(currency: CurrencyType.złoty.name,
                                                amount: model.amount)
        
        let debitAccounData = ItAccountDataParameters(accountNo: debitAccountFormated,
                                                      accountName: nil,
                                                      accountSequenceNumber: model.account.accountSequenceNumber,
                                                      accountType: model.account.accountType)
        
        let creditAccountData = ItAccountDataParameters(accountNo: creditAccountFormated,
                                                        accountName: model.recipientName,
                                                        accountSequenceNumber: 0,
                                                        accountType: 90)
        
        let date = model.date?.toString(format: TimeFormat.yyyyMMdd.rawValue) ?? ""
        let transferType: AcceptDomesticTransactionParameters.TransferType = .INTERNAL
        let transactionParametersInput = PLDomesticTransactionParametersInput(
            debitAccountNumber: debitAccountFormated,
            creditAccountNumber: creditAccountFormated,
            debitAmount: model.amount,
            userID: String(describing: userId)
        )
        
        let signData = SignDataParameters(securityLevel: 2048)
        
        let transactionParameters = transactionParametersProvider.getTransactionParameters(
            type: .charityTransfer(transactionParametersInput)
        )
        return GenericSendMoneyConfirmationInput(
            customerAddressData: nil,
            debitAmountData: amountData,
            creditAmountData: amountData,
            debitAccountData: debitAccounData,
            creditAccountData: creditAccountData,
            signData: signData,
            title: model.title,
            type: AcceptDomesticTransactionParameters.TransactionType.ONEAPP_MOBILE_TRANSACTION.rawValue,
            transferType: transferType.rawValue,
            valueDate: date,
            transactionParameters: transactionParameters
        )
    }
    
    func mapPartialNotifyDeviceInput(with model: CharityTransferModel) -> PartialNotifyDeviceInput {
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
            variables: ["\(model.amount)", CurrencyType.złoty.name, model.recipientAccountNumber, recipientName]
        )
    }
}

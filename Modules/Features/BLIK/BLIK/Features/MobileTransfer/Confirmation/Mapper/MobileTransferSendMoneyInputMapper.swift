import Foundation
import CoreFoundationLib
import SANPLLibrary
import SANLegacyLibrary
import PLCommons
import PLCommonOperatives

protocol MobileTransferSendMoneyInputMapping {
    func map(with model: MobileTransferViewModel, dstAccNo: String, isDstAccInternal: Bool, userId: Int) -> GenericSendMoneyConfirmationInput
    func mapPartialNotifyDeviceInput(with model: MobileTransferViewModel, dstAccNo: String, isDstAccInternal: Bool) -> PartialNotifyDeviceInput
}

final class MobileTransferSendMoneyInputMapper: MobileTransferSendMoneyInputMapping {
    private let transactionParametersProvider: PLTransactionParametersProviderProtocol
    
    init(dependenciesResolver: DependenciesResolver) {
        transactionParametersProvider = dependenciesResolver.resolve(for: PLTransactionParametersProviderProtocol.self)
    }
    
    func map(with model: MobileTransferViewModel, dstAccNo: String, isDstAccInternal: Bool, userId: Int) -> GenericSendMoneyConfirmationInput {
        let debitAccountFormated = IBANFormatter.formatIbanToNrb(
            for: model.account.number
        )
        let creditAccountFormated = IBANFormatter.formatIbanToNrb(
            for: dstAccNo
        )
        
        let amountData = ItAmountDataParameters(currency: CurrencyType.złoty.name,
                                                amount: model.amount)
        
        let debitAccounData = ItAccountDataParameters(accountNo: debitAccountFormated,
                                                      accountName: model.account.name,
                                                      accountSequenceNumber: model.account.accountSequenceNumber,
                                                      accountType: model.account.accountType)
        
        let creditAccountData = ItAccountDataParameters(accountNo: creditAccountFormated,
                                                        accountName: model.recipientName,
                                                        accountSequenceNumber: 0,
                                                        accountType: 90)
        
        let date = model.date?.toString(format: TimeFormat.yyyyMMdd.rawValue) ?? ""
        let signData = SignDataParameters(securityLevel: 2048)
        
        let transferType: AcceptDomesticTransactionParameters.TransferType = isDstAccInternal ? .INTERNAL : .BLIK_P2P
        
        return GenericSendMoneyConfirmationInput(
            customerAddressData: nil,
            debitAmountData: amountData,
            creditAmountData: amountData,
            debitAccountData: debitAccounData,
            creditAccountData: creditAccountData,
            signData: signData,
            title: model.title,
            type: AcceptDomesticTransactionParameters.TransactionType.ONEAPP_BLIK_P2P_TRANSACTION.rawValue,
            transferType: transferType.rawValue,
            valueDate: date,
            transactionParameters: nil
        )
    }
    
    func mapPartialNotifyDeviceInput(with model: MobileTransferViewModel, dstAccNo: String, isDstAccInternal: Bool) -> PartialNotifyDeviceInput {
        let iban = IBANRepresented(ibanString: IBANFormatter.formatIbanToNrb(for: dstAccNo))
        let amount = AmountDTO(
            value: model.amount,
            currency: CurrencyDTO(
                currencyName: CurrencyType.złoty.name,
                currencyType: .złoty
            )
        )
        
        return PartialNotifyDeviceInput(
            softwareTokenType: nil,
            notificationSchemaId: "466",
            alias: "",
            iban: iban,
            amount: amount,
            variables: []
        )
    }
}

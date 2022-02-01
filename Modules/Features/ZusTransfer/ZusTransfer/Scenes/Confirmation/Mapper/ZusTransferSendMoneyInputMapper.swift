import Foundation
import CoreFoundationLib
import SANPLLibrary
import SANLegacyLibrary
import PLCommons

protocol ZusTransferSendMoneyInputMapping {
    func map(with input: AcceptZusTransactionUseCaseInput, userId: Int) -> GenericSendMoneyConfirmationInput
}

final class ZusTransferSendMoneyInputMapper: ZusTransferSendMoneyInputMapping {
    private let transactionParametersProvider: PLTransactionParametersProviderProtocol
    
    init(dependenciesResolver: DependenciesResolver) {
        transactionParametersProvider = dependenciesResolver.resolve(for: PLTransactionParametersProviderProtocol.self)
    }
    
    func map(with input: AcceptZusTransactionUseCaseInput, userId: Int) -> GenericSendMoneyConfirmationInput {
        let debitAccountFormated = IBANFormatter.formatIbanToNrb(
            for: input.model.account.number
        )
        let creditAccountFormated = IBANFormatter.formatIbanToNrb(
            for: input.model.recipientAccountNumber
        )
        
        let amountData = ItAmountDataParameters(currency: CurrencyType.złoty.name,
                                                amount: input.model.amount)
        
        let debitAccounData = ItAccountDataParameters(accountNo: debitAccountFormated,
                                                      accountName: input.model.account.name,
                                                      accountSequenceNumber: input.model.account.accountSequenceNumber,
                                                      accountType: input.model.account.accountType)
        
        let creditAccountData = ItAccountDataParameters(accountNo: creditAccountFormated,
                                                        accountName: input.model.recipientName,
                                                        accountSequenceNumber: 0,
                                                        accountType: 80)
        
        let date = input.model.date?.toString(format: TimeFormat.yyyyMMdd.rawValue) ?? ""
        let transferType: AcceptDomesticTransactionParameters.TransferType = .ZUS
        let transactionParametersInput = PLDomesticTransactionParametersInput(
            debitAccountNumber: debitAccountFormated,
            creditAccountNumber: creditAccountFormated,
            debitAmount: input.model.amount,
            userID: String(describing: userId)
        )
        
        let transactionParameters = transactionParametersProvider.getTransactionParameters(
            type: .zusTransfer(transactionParametersInput)
        )
        return GenericSendMoneyConfirmationInput(
            customerAddressData: nil,
            debitAmountData: amountData,
            creditAmountData: amountData,
            debitAccountData: debitAccounData,
            creditAccountData: creditAccountData,
            signData: nil,
            title: input.model.title,
            type: AcceptDomesticTransactionParameters.TransactionType.ZUS_TRANSACTION.rawValue,
            transferType: transferType.rawValue,
            valueDate: date,
            transactionParameters: transactionParameters
        )
    }
}

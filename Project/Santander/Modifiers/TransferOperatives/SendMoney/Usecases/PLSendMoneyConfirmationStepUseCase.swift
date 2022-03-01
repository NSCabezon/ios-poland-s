//
//  PLSendMoneyConfirmationStepUseCase.swift
//  Santander
//
//  Created by José María Jiménez Pérez on 16/11/21.
//

import TransferOperatives
import CoreFoundationLib
import SANPLLibrary

final class PLSendMoneyConfirmationStepUseCase: UseCase<SendMoneyConfirmationStepUseCaseInput, SendMoneyTransferSummaryState, StringErrorOutput> {
    
    private let dependenciesResolver: DependenciesResolver
    
    init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
    }
    
    override func executeUseCase(requestValues: SendMoneyConfirmationStepUseCaseInput) throws -> UseCaseResponse<SendMoneyTransferSummaryState, StringErrorOutput> {
        let transferType = self.dependenciesResolver.resolve(forOptionalType: SendMoneyModifierProtocol.self)?.transferTypeFor(onePayType: requestValues.type, subtype: requestValues.subType?.serviceString ?? "")
        let amountData = ItAmountDataParameters(currency: requestValues.amount.currencyRepresentable?.currencyName, amount: requestValues.amount.value)
        guard let originAccount = requestValues.originAccount as? PolandAccountRepresentable,
              let ibanRepresentable = requestValues.originAccount.ibanRepresentable else { return .error(ValidateTransferUseCaseErrorOutput(.serviceError(errorDesc: nil))) }
        let customerAddressData = CustomerAddressDataParameters(customerName: requestValues.name,
                                                                city: nil,
                                                                street: nil,
                                                                zipCode: nil,
                                                                baseAddress: nil)
        let signData = SignDataParameters(securityLevel: 2048)
        let originIBAN: String = ibanRepresentable.countryCode + ibanRepresentable.checkDigits + ibanRepresentable.codBban
        let destinationIBAN = requestValues.destinationIBAN.countryCode + requestValues.destinationIBAN.checkDigits + requestValues.destinationIBAN.codBban
        let debitAccounData = ItAccountDataParameters(accountNo: originIBAN,
                                                      accountName: nil,
                                                      accountSequenceNumber: originAccount.sequencerNo,
                                                      accountType: originAccount.accountType)
        
        let creditAccountData = ItAccountDataParameters(accountNo: destinationIBAN,
                                                        accountName: (requestValues.name ?? "") + (requestValues.payeeSelected?.payeeAddress ?? ""),
                                                        accountSequenceNumber: 0,
                                                        accountType: 90)
        var valueDate: String?
        if case .day(let date) = requestValues.time {
            valueDate = date.toString(format: "YYYY-MM-dd")
        }
        let sendMoneyConfirmationInput = GenericSendMoneyConfirmationInput(customerAddressData: customerAddressData,
                                                                           debitAmountData: amountData,
                                                                           creditAmountData: amountData,
                                                                           debitAccountData: debitAccounData,
                                                                           creditAccountData: creditAccountData,
                                                                           signData: signData,
                                                                           title: requestValues.concept,
                                                                           type: requestValues.transactionType,
                                                                           transferType: transferType,
                                                                           valueDate: valueDate)
        let manager = self.dependenciesResolver.resolve(for: PLManagersProviderProtocol.self).getTransferManager()
        let result = try manager.sendConfirmation(sendMoneyConfirmationInput)
        switch result {
        case .success(let confirmationTrasferDTO):
            if let state = confirmationTrasferDTO.state, let confirmationResult = ConfirmationResultType(rawValue: state) {
                switch confirmationResult {
                case .accepted:
                    return .ok(.success())
                default:
                    return .error(StringErrorOutput(nil))
                }
            } else {
                return .error(StringErrorOutput(nil))
            }
        case .failure(let error):
            guard let errorDTO: PLErrorDTO = error.getErrorBody(),
                  let parsedError = errorMessages[errorDTO.errorCode2]
            else {
                return .error(ValidateTransferUseCaseErrorOutput(.serviceError(errorDesc: error.localizedDescription)))
            }
            return .ok(.success(title: parsedError.0, subtitle: parsedError.1))
        }
    }
}

enum ConfirmationResultType: String {
    case trashBin = "TRASH_BIN"
    case modifiedTrashBin = "MODIFIED_TRASH_BIN"
    case externalOrder = "EXTERNAL_ORDER"
    case waitRoom = "WAIT_ROOM"
    case partiallySigned = "PARTIALLY_SIGNED"
    case signed = "SIGNED"
    case externalOrderPosted = "EXTERNAL_ORDER_POSTED"
    case accepted = "ACCEPTED"
    case acceptedWithBlock = "ACCEPTED_WITH_BLOCK"
    case sent = "SENT"
    case cancelled = "CANCELLED"
    case poster = "POSTED"
    case memoPosted = "MEMO_POSTED"
    case error = "ERROR"
    case errorInsufficientFunds = "ERROR_INSUFFICIENT_FUNDS"
    case errorClosedAccount = "ERROR_CLOSED_ACCOUNT"
    case errorNoAccount = "ERROR_NO_ACCOUNT"
    case errorManualDeny = "ERROR_MANUAL_DENY"
    case errorOtherReason = "ERROR_OTHER_REASON"
    case errorNoProduct = "ERROR_NO_PRODUCT"
    case errorAgainstInstruction = "ERROR_AGAINST_INSTRUCTION"
    case errorToSmallAmoubt = "ERROR_TO_SMALL_AMOUNT"
    case errorToBigAmount = "ERROR_TO_BIG_AMOUNT"
    case errorBNFBankRejected = "ERROR_BNF_BANK_REJECTED"
    case errorFraud = "ERROR_FRAUD"
    case errorOther = "ERROR_OTHER"
    case errorBadCheckSum = "ERROR_BAD_CHECK_SUM"
    case errorCheckSum = "ERROR_CHECK_SUM"
}

extension PLSendMoneyConfirmationStepUseCase: SendMoneyConfirmationStepUseCaseProtocol { }

// MARK: - Service messages errors

private extension PLSendMoneyConfirmationStepUseCase {
    
    var errorMessages: [Int: (String, String)] {
        var errorArray: [Int: (String, String)] = [:]
        let reLogCodes = [2, 3, 4, 5, 11, 13, 17, 21, 30, 79, 130, 170, 171, 172, 173, 174]
        reLogCodes.forEach {
            errorArray[$0] = ("pl_summary_label_transactionNotCompleted", "pl_summary_label_reLogApplication")
        }
        let passwordExpiredCodes = [7, 8]
        passwordExpiredCodes.forEach {
            errorArray[$0] = ("pl_summary_label_transactionNotCompleted", "pl_summary_label_passwordExpired")
        }
        let exchangeCodes = [14, 15, 23, 100]
        exchangeCodes.forEach {
            errorArray[$0] = ("pl_summary_label_transactionNotCompleted", "pl_summary_label_currencyExchangeRates")
        }
        errorArray[41] = ("pl_summary_label_transactionNotCompleted", "pl_summary_label_checkSenderRecipient")
        errorArray[42] = ("pl_summary_label_transactionNotCompleted", "pl_summary_label_minimumTransferAmount")
        errorArray[43] = ("pl_summary_label_transactionNotCompleted", "pl_summary_label_TransferTooLarge")
        errorArray[99] = ("pl_summary_label_transactionNotCompleted", "pl_summary_label_transferOnlyOurBranch")
        let blockedCodes = [251, 252]
        blockedCodes.forEach {
            errorArray[$0] = ("pl_summary_label_transactionNotCompleted", "pl_summary_label_blockedAccessingTransactionService")
        }
        return errorArray
    }
}

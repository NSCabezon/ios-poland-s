//
//  SendMoneyValidationProtocol.swift
//  Santander
//
//  Created by Angel Abad Perez on 23/2/22.
//

import CoreFoundationLib
import TransferOperatives
import CoreDomain
import SANPLLibrary

public protocol SendMoneyValidationProtocol: AnyObject {
    var notificationSchemaId: String { get }
    var dependenciesResolver: DependenciesResolver { get }
    func validateTransfer(requestValues: SendMoneyOperativeData) throws -> UseCaseResponse<SendMoneyOperativeData, StringErrorOutput>
}

public extension SendMoneyValidationProtocol {
    var notificationSchemaId: String { return "195" }
    
    func validateTransfer(requestValues: SendMoneyOperativeData) throws -> UseCaseResponse<SendMoneyOperativeData, StringErrorOutput> {
        switch requestValues.transferDateType {
        case .now, .day:
            return try self.performValidation(requestValues: requestValues)
        case .periodic, .none:
            return UseCaseResponse.error(StringErrorOutput(nil))
        }
    }
}

private extension SendMoneyValidationProtocol {
    var transferRepository: PLTransfersRepository {
        return dependenciesResolver.resolve()
    }
    
    func performValidation(requestValues: SendMoneyOperativeData) throws -> UseCaseResponse<SendMoneyOperativeData, StringErrorOutput> {
        guard let originAccount = requestValues.selectedAccount as? PolandAccountRepresentable,
              let originIbanRepresentable = requestValues.selectedAccount?.ibanRepresentable,
              let destinationIbanRepresentable = requestValues.destinationIBANRepresentable,
              let amount = requestValues.amount
        else {
            return .error(ValidateTransferUseCaseErrorOutput(.serviceError(errorDesc: nil)))
        }
        let transferType: String? = self.dependenciesResolver.resolve(forOptionalType: SendMoneyModifierProtocol.self)?.transferTypeFor(onePayType: requestValues.type, subtype: requestValues.selectedTransferType?.type.serviceString ?? "")
        let amountData = ItAmountDataParameters(currency: amount.currencyRepresentable?.currencyName, amount: amount.value)
        let originIBAN: String = originIbanRepresentable.countryCode + originIbanRepresentable.checkDigits + originIbanRepresentable.codBban
        let destinationIBAN = destinationIbanRepresentable.countryCode + destinationIbanRepresentable.checkDigits + destinationIbanRepresentable.codBban
        let debitAccounData = ItAccountDataParameters(accountNo: originIBAN,
                                                      accountName: nil,
                                                      accountSequenceNumber: originAccount.sequencerNo,
                                                      accountType: originAccount.accountType)
        let creditAccountData = ItAccountDataParameters(accountNo: destinationIBAN,
                                                        accountName: (requestValues.destinationName ?? "") + (requestValues.selectedPayee?.payeeAddress ?? ""),
                                                        accountSequenceNumber: 0,
                                                        accountType: 90)
        var valueDate: String?
        if case .day(let date) = requestValues.transferFullDateType {
            valueDate = date.toString(format: "YYYY-MM-dd")
        }
        let sendMoneyConfirmationInput = GenericSendMoneyConfirmationInput(customerAddressData: nil,
                                                                           debitAmountData: amountData,
                                                                           creditAmountData: amountData,
                                                                           debitAccountData: debitAccounData,
                                                                           creditAccountData: creditAccountData,
                                                                           signData: nil,
                                                                           title: requestValues.description,
                                                                           type: requestValues.specialPricesOutput?.transactionTypeString,
                                                                           transferType: transferType,
                                                                           valueDate: valueDate)
        let result = try self.transferRepository.getChallenge(parameters: sendMoneyConfirmationInput)
        switch result {
        case .success(let challengeDTO):
            guard let challengeString = challengeDTO.challengeRepresentable else { return .error(ValidateTransferUseCaseErrorOutput(.serviceError(errorDesc: nil)))
            }
            return try self.executeNotifyDevice(challengeString,
                                                requestValues: requestValues,
                                                // TODO: CHANGE TO ALIAS
                                                alias: requestValues.destinationName ?? "",
                                                destinationAccountNumber: destinationIbanRepresentable,
                                                amount: amount)
        case .failure(let error):
            return .error(ValidateTransferUseCaseErrorOutput(.serviceError(errorDesc: error.localizedDescription)))
        }
    }
    
    func executeNotifyDevice(_ challenge: String, requestValues: SendMoneyOperativeData, alias: String, destinationAccountNumber: IBANRepresentable, amount: AmountRepresentable) throws -> UseCaseResponse<SendMoneyOperativeData, StringErrorOutput> {
        let input = NotifyDeviceInput(challenge: challenge,
                                      softwareTokenType: nil,
                                      notificationSchemaId: self.notificationSchemaId,
                                      alias: alias,
                                      iban: destinationAccountNumber,
                                      amount: amount)
        let result = try self.transferRepository.notifyDevice(input)
        switch result {
        case .success(let authorizationId):
            guard let authorizationIdString = authorizationId.authorizationId else {
                return .error(ValidateTransferUseCaseErrorOutput(.serviceError(errorDesc: nil)))
            }
            requestValues.scaRepresentable = ValidateSendMoneySCA(authorizationId: "\(authorizationIdString)")
            return .ok(requestValues)
        case .failure(let error):
            return .error(ValidateTransferUseCaseErrorOutput(.serviceError(errorDesc: error.localizedDescription)))
        }
    }
}

private final class ValidateSendMoneySCA: SCARepresentable {
    init(authorizationId: String) {
        self.authorizationId = authorizationId
    }
    let authorizationId: String
    var type: SCARepresentableType { return .oap(authorizationId) }
}

import Foundation
import CoreFoundationLib
import TransferOperatives
import SANPLLibrary
import CoreDomain

class PLValidateGenericSendMoneyUseCase: UseCase<ValidateSendMoneyUseCaseInput, ValidateSendMoneyUseCaseOkOutput, StringErrorOutput>, ValidateGenericSendMoneyUseCaseProtocol {
    let dependenciesResolver: DependenciesResolver
    var transferRepository: PLTransfersRepository {
        return dependenciesResolver.resolve()
    }
    
    init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
    }
    
    override func executeUseCase(requestValues: ValidateSendMoneyUseCaseInput) throws -> UseCaseResponse<ValidateSendMoneyUseCaseOkOutput, StringErrorOutput> {
        let transferType = requestValues.subType?.serviceString ?? ""
        let amountData = ItAmountDataParameters(currency: requestValues.amount.currencyRepresentable?.currencyName, amount: requestValues.amount.value)
        guard let originAccount = requestValues.originAccount as? PolandAccountRepresentable,
              let ibanRepresentable = requestValues.originAccount.ibanRepresentable else { return .error(ValidateTransferUseCaseErrorOutput(.serviceError(errorDesc: nil))) }
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
        let sendMoneyConfirmationInput = GenericSendMoneyConfirmationInput(customerAddressData: nil,
                                                                           debitAmountData: amountData,
                                                                           creditAmountData: amountData,
                                                                           debitAccountData: debitAccounData,
                                                                           creditAccountData: creditAccountData,
                                                                           signData: nil,
                                                                           title: requestValues.concept,
                                                                           type: requestValues.transactionType,
                                                                           transferType: transferType,
                                                                           valueDate: valueDate)
        
        let result = try self.transferRepository.getChallenge(parameters: sendMoneyConfirmationInput)
        switch result {
        case .success(let challengeDTO):
            guard let challengeString = challengeDTO.challengeRepresentable else { return .error(ValidateTransferUseCaseErrorOutput(.serviceError(errorDesc: nil)))
            }
            return try self.executeNotifyDevice(challengeString,
                                                alias: requestValues.name ?? "",
                                                destinationAccountNumber: requestValues.destinationIBAN,
                                                amount: requestValues.amount)
        case .failure(let error):
            return .error(ValidateTransferUseCaseErrorOutput(.serviceError(errorDesc: error.localizedDescription)))
        }
    }
}

extension PLValidateGenericSendMoneyUseCase: ValidateScheduledSendMoneyUseCaseProtocol { }

private extension PLValidateGenericSendMoneyUseCase {
    enum Constants {
        public static let notificationSchemaId = "195"
    }
    
    func executeNotifyDevice(_ challenge: String, alias: String, destinationAccountNumber: IBANRepresentable, amount: AmountRepresentable) throws -> UseCaseResponse<ValidateSendMoneyUseCaseOkOutput, StringErrorOutput> {
        let input = NotifyDeviceInput(challenge: challenge,
                                      softwareTokenType: nil,
                                      notificationSchemaId: Constants.notificationSchemaId,
                                      alias: alias,
                                      iban: destinationAccountNumber,
                                      amount: amount)
        let result = try self.transferRepository.notifyDevice(input)
        switch result {
        case .success(let authorizationId):
            guard let authorizationIdString = authorizationId.authorizationId else {
                return .error(ValidateTransferUseCaseErrorOutput(.serviceError(errorDesc: nil)))
            }
            return .ok(ValidateSendMoneyUseCaseOkOutput(beneficiaryMail: nil, sca: SCAEntity(ValidateSendMoneySCA(authorizationId: "\(authorizationIdString)"))))
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

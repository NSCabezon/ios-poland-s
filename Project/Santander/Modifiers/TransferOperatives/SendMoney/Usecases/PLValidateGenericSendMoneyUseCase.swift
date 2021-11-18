import Foundation
import DomainCommon
import TransferOperatives
import SANPLLibrary
import Commons
import Models
import CoreDomain

class PLValidateGenericSendMoneyUseCase: UseCase<ValidateSendMoneyUseCaseInput, ValidateSendMoneyUseCaseOkOutput, ValidateTransferUseCaseErrorOutput>, ValidateGenericSendMoneyUseCaseProtocol {
    let dependenciesResolver: DependenciesResolver
    var transferRepository: PLTransfersRepository {
        return dependenciesResolver.resolve()
    }
    
    init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
    }
    
    override func executeUseCase(requestValues: ValidateSendMoneyUseCaseInput) throws -> UseCaseResponse<ValidateSendMoneyUseCaseOkOutput, ValidateTransferUseCaseErrorOutput> {
        let transferType = self.dependenciesResolver.resolve(forOptionalType: SendMoneyModifierProtocol.self)?.transferTypeFor(onePayType: requestValues.type, subtype: requestValues.subType?.serviceString ?? "")
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
        
        let sendMoneyConfirmationInput = GenericSendMoneyConfirmationInput(customerAddressData: nil,
                                                                           debitAmountData: amountData,
                                                                           creditAmountData: amountData,
                                                                           debitAccountData: debitAccounData,
                                                                           creditAccountData: creditAccountData,
                                                                           signData: nil,
                                                                           title: requestValues.concept,
                                                                           type: requestValues.transactionType,
                                                                           transferType: transferType)
        
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

private extension PLValidateGenericSendMoneyUseCase {
    enum Constants {
        public static let notificationSchemaId = "195"
    }
    
    func executeNotifyDevice(_ challenge: String, alias: String, destinationAccountNumber: IBANRepresentable, amount: AmountRepresentable) throws -> UseCaseResponse<ValidateSendMoneyUseCaseOkOutput, ValidateTransferUseCaseErrorOutput> {
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
            return .ok(ValidateSendMoneyUseCaseOkOutput(beneficiaryMail: nil, sca: ValidateSendMoneySCA(authorizationId: "\(authorizationIdString)")))
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

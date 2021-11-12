import Foundation
import DomainCommon
import TransferOperatives
import SANPLLibrary
import Commons

class PLValidateGenericSendMoneyUseCase: UseCase<ValidateSendMoneyUseCaseInput, ValidateSendMoneyUseCaseOkOutput, ValidateTransferUseCaseErrorOutput>, ValidateGenericSendMoneyUseCaseProtocol {
    let dependenciesResolver: DependenciesResolver
    var transferRepository: PLTransfersRepository {
        return dependenciesResolver.resolve()
    }
    
    init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
    }
    
    override func executeUseCase(requestValues: ValidateSendMoneyUseCaseInput) throws -> UseCaseResponse<ValidateSendMoneyUseCaseOkOutput, ValidateTransferUseCaseErrorOutput> {
        let sendMoneyConfirmationInput = GenericSendMoneyConfirmationInput(customerAddressData: nil,
                                                                           debitAmountData: nil,
                                                                           creditAmountData: nil,
                                                                           debitAccountData: nil,
                                                                           creditAccountData: nil,
                                                                           signData: nil,
                                                                           title: nil,
                                                                           type: nil,
                                                                           transferType: nil)
        let result = try self.transferRepository.getChallenge(parameters: sendMoneyConfirmationInput)
        switch result {
        case .success(let challengeDTO):
            // TODO: Call notify-device
            fatalError()
            break
        case .failure(let error):
            return .error(ValidateTransferUseCaseErrorOutput(.serviceError(errorDesc: error.localizedDescription)))
        }
    }
}

private extension PLValidateGenericSendMoneyUseCase {
    // TODO: Develop this function creating the input and calling the service
//    func executeNotifyDevice(_ challenge: String) throws -> UseCaseResponse<ValidateSendMoneyUseCaseOkOutput, ValidateTransferUseCaseErrorOutput> {
//        let input = NotifyDeviceInput()
//        let result = try self.transferRepository.notifyDevice(input)
//        switch result {
//        case .success(let authorizationId):
//            // TODO: Call notify-device
//            fatalError()
//            break
//        case .failure(let error):
//            return .error(ValidateTransferUseCaseErrorOutput(.serviceError(errorDesc: error.localizedDescription)))
//        }
//    }
}

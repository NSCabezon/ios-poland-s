import TransferOperatives
import DomainCommon
import SANPLLibrary
import Commons

final class IbanValidationSendMoneyUseCase: UseCase<IbanValidationSendMoneyUseCaseInput, IbanValidationSendMoneyUseCaseOkOutput, DestinationAccountSendMoneyUseCaseErrorOutput>, IbanValidationSendMoneyUseCaseProtocol {
    private var transfersRepository: PLTransfersRepository
    
    public init(dependenciesResolver: DependenciesResolver) {
        self.transfersRepository = dependenciesResolver.resolve()
    }
    
    override public func executeUseCase(requestValues: IbanValidationSendMoneyUseCaseInput) throws -> UseCaseResponse<IbanValidationSendMoneyUseCaseOkOutput, DestinationAccountSendMoneyUseCaseErrorOutput> {
        guard let iban = requestValues.iban else {
            return .error(DestinationAccountSendMoneyUseCaseErrorOutput(.ibanInvalid))
        }
        let response = try transfersRepository.checkInternalAccount(input: CheckInternalAccountInput(destinationAccount: iban))
        let checkInternalAccountDto: CheckInternalAccountRepresentable
        switch response {
        case .success(let dto):
            checkInternalAccountDto = dto
        case .failure:
            return .error(DestinationAccountSendMoneyUseCaseErrorOutput(.ibanInvalid))
        }
        
        guard let name = requestValues.name, name.trim().count > 0 else {
            return .error(DestinationAccountSendMoneyUseCaseErrorOutput(.noToName))
        }
        if requestValues.saveFavorites {
            guard let alias = requestValues.alias, alias.trim().count > 0 else {
                return .error(DestinationAccountSendMoneyUseCaseErrorOutput(.noAlias))
            }
            let duplicate = requestValues.favouriteList.first { return $0.baoName?.trim() == alias.trim() }
            guard duplicate == nil else {
                return .error(DestinationAccountSendMoneyUseCaseErrorOutput(.duplicateAlias(alias: alias)))
            }
        }
        return .ok(.data(checkInternalAccountDto))
    }
}

//
//  PolandSendMoneyDestinationUseCase.swift
//  Santander
//
//  Created by David Gálvez Alonso on 3/2/22.
//

import CoreFoundationLib
import TransferOperatives
import Commons
import SANPLLibrary

final class PolandSendMoneyDestinationUseCase: UseCase<SendMoneyOperativeData, SendMoneyOperativeData, DestinationAccountSendMoneyUseCaseErrorOutput>, SendMoneyDestinationUseCaseProtocol {
    
    private var bankingUtils: BankingUtilsProtocol
    private var transfersRepository: PLTransfersRepository

    public init(dependenciesResolver: DependenciesResolver) {
        self.bankingUtils = dependenciesResolver.resolve()
        self.transfersRepository = dependenciesResolver.resolve()
    }
    
    override func executeUseCase(requestValues: SendMoneyOperativeData) throws -> UseCaseResponse<SendMoneyOperativeData, DestinationAccountSendMoneyUseCaseErrorOutput> {
        guard let iban = requestValues.destinationIBANRepresentable,
              !iban.ibanString.isEmpty,
              bankingUtils.isValidIban(ibanString: iban.ibanString) else {
            return .error(DestinationAccountSendMoneyUseCaseErrorOutput(.ibanInvalid))
        }
        let response = try transfersRepository.checkInternalAccount(input: CheckInternalAccountInput(destinationAccount: iban))
        let checkInternalAccountDto: CheckInternalAccountRepresentable
        switch response {
        case .success(let dto):
            checkInternalAccountDto = dto
        case .failure(let error):
            return .error(DestinationAccountSendMoneyUseCaseErrorOutput(.serviceError(errorDesc: error.localizedDescription)))
        }
        requestValues.ibanValidationOutput = .data(checkInternalAccountDto)
        guard let name = requestValues.destinationAlias, name.trim().count > 0 else {
            return .error(DestinationAccountSendMoneyUseCaseErrorOutput(.noToName))
        }
        if requestValues.saveToFavorite {
            guard let alias = requestValues.destinationAlias, alias.trim().count > 0 else {
                return .error(DestinationAccountSendMoneyUseCaseErrorOutput(.noAlias))
            }
            let duplicate = requestValues.fullFavorites?.first { return $0.payeeName?.trim() == alias.trim() }
            guard duplicate == nil else {
                return .error(DestinationAccountSendMoneyUseCaseErrorOutput(.duplicateAlias(alias: alias)))
            }
        }
        return .ok(requestValues)
    }
}

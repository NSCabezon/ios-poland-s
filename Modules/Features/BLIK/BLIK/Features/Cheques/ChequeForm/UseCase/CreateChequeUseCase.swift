//
//  CreateChequeUseCase.swift
//  BLIK
//
//  Created by Piotr Mielcarzewicz on 14/07/2021.
//

import Commons
import Foundation
import DomainCommon
import SANPLLibrary


protocol CreateChequeUseCaseProtocol: UseCase<CreateChequeRequest, Void, StringErrorOutput> {}

final class CreateChequeUseCase: UseCase<CreateChequeRequest, Void, StringErrorOutput> {
    private let secondsInHour = 3600
    private let managersProvider: PLManagersProviderProtocol
    
    init(
        managersProvider: PLManagersProviderProtocol
    ) {
        self.managersProvider = managersProvider
    }
    
    override func executeUseCase(requestValues: CreateChequeRequest) throws -> UseCaseResponse<Void, StringErrorOutput> {
        let request = CreateChequeRequestDTO(
            ticketTime: requestValues.ticketTime * secondsInHour,
            ticketName: requestValues.ticketName,
            ticketAmount: requestValues.ticketAmount,
            ticketCurrency: requestValues.ticketCurrency
        )
        let result = try managersProvider.getBLIKManager().createCheque(request: request)
        switch result {
        case .success:
            return .ok()
        case .failure(let error):
            return .error(.init(error.localizedDescription))
        }
    }
}

extension CreateChequeUseCase: CreateChequeUseCaseProtocol {}

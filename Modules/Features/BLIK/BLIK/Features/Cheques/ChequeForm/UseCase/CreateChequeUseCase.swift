//
//  CreateChequeUseCase.swift
//  BLIK
//
//  Created by Piotr Mielcarzewicz on 14/07/2021.
//

import CoreFoundationLib
import Foundation
import SANPLLibrary


protocol CreateChequeUseCaseProtocol: UseCase<CreateChequeUseCaseInput, Void, StringErrorOutput> {}

final class CreateChequeUseCase: UseCase<CreateChequeUseCaseInput, Void, StringErrorOutput> {
    private let dependenciesResolver: DependenciesResolver
    private let secondsInHour = 3600
    
    init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
    }
    
    override func executeUseCase(requestValues: CreateChequeUseCaseInput) throws -> UseCaseResponse<Void, StringErrorOutput> {
        let request = CreateChequeRequestDTO(
            ticketTime: requestValues.chequeRequest.ticketTime * secondsInHour,
            ticketName: requestValues.chequeRequest.ticketName,
            ticketAmount: requestValues.chequeRequest.ticketAmount,
            ticketCurrency: requestValues.chequeRequest.ticketCurrency
        )
        let managersProvider: PLManagersProviderProtocol = dependenciesResolver.resolve(
            for: PLManagersProviderProtocol.self
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

struct CreateChequeUseCaseInput {
    let chequeRequest: CreateChequeRequest
}

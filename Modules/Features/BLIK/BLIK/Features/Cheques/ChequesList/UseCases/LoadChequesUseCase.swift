//
//  LoadChequesUseCase.swift
//  BLIK
//
//  Created by Piotr Mielcarzewicz on 14/06/2021.
//

import Commons
import Foundation
import DomainCommon
import SANPLLibrary

protocol LoadChequesUseCaseProtocol: UseCase<LoadChequesUseCaseInput, LoadChequesUseCaseOutput, StringErrorOutput> {}

final class LoadChequesUseCase: UseCase<LoadChequesUseCaseInput, LoadChequesUseCaseOutput, StringErrorOutput> {
    private let dependenciesResolver: DependenciesResolver
    
    init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
    }
    
    override func executeUseCase(requestValues: LoadChequesUseCaseInput) throws -> UseCaseResponse<LoadChequesUseCaseOutput, StringErrorOutput> {
        let managersProvider: PLManagersProviderProtocol = dependenciesResolver.resolve(
            for: PLManagersProviderProtocol.self
        )
        let modelMapper: ChequeModelMapping =
            dependenciesResolver.resolve(
                for: ChequeModelMapping.self
            )
        let result: Result<[BlikChequeDTO], NetworkProviderError> = try {
            switch requestValues.chequeListType {
            case .active:
                return try managersProvider.getBLIKManager().getActiveCheques()
            case .archived:
                return try managersProvider.getBLIKManager().getArchivedCheques()
            }
        }()
        
        switch result {
        case let .success(dtos):
            do {
                let models = try dtos.map { try modelMapper.map(dto: $0) }
                return .ok(
                    LoadChequesUseCaseOutput(chequeList: models)
                )
            } catch {
                return .error(.init(error.localizedDescription))
            }
        case .failure(let error):
            return .error(.init(error.localizedDescription))
        }
    }
}

extension LoadChequesUseCase: LoadChequesUseCaseProtocol {}

struct LoadChequesUseCaseInput {
    let chequeListType: ChequeListType
}

struct LoadChequesUseCaseOutput {
    let chequeList: [BlikCheque]
}

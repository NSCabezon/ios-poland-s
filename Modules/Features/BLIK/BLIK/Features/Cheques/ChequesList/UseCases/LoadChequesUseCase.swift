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

protocol LoadChequesUseCaseProtocol: UseCase<ChequeListType, [BlikCheque], StringErrorOutput> {}

final class LoadChequesUseCase: UseCase<ChequeListType, [BlikCheque], StringErrorOutput> {
    private let managersProvider: PLManagersProviderProtocol
    private let modelMapper: ChequeModelMapping
    
    init(
        managersProvider: PLManagersProviderProtocol,
        modelMapper: ChequeModelMapping
    ) {
        self.managersProvider = managersProvider
        self.modelMapper = modelMapper
    }
    
    override func executeUseCase(requestValues: ChequeListType) throws -> UseCaseResponse<[BlikCheque], StringErrorOutput> {
        let result: Result<[BlikChequeDTO], NetworkProviderError> = try {
            switch requestValues {
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
                return .ok(models)
            } catch {
                return .error(.init(error.localizedDescription))
            }
        case .failure(let error):
            return .error(.init(error.localizedDescription))
        }
    }
}

extension LoadChequesUseCase: LoadChequesUseCaseProtocol {}

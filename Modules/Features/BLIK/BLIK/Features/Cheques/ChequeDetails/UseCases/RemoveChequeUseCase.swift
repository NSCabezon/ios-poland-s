//
//  RemoveChequeUseCase.swift
//  BLIK
//
//  Created by 186491 on 17/06/2021.
//

import Commons
import Foundation
import DomainCommon
import SANPLLibrary

protocol RemoveChequeUseCaseProtocol: UseCase<RemoveChequeUseCaseInput, Void, StringErrorOutput> {}

final class RemoveChequeUseCase: UseCase<RemoveChequeUseCaseInput, Void, StringErrorOutput> {
   
    private let dependenciesResolver: DependenciesResolver

    init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
    }
    
    override func executeUseCase(requestValues: RemoveChequeUseCaseInput) throws -> UseCaseResponse<Void, StringErrorOutput> {
        let managersProvider: PLManagersProviderProtocol = dependenciesResolver.resolve(
            for: PLManagersProviderProtocol.self
        )
        let result = try managersProvider.getBLIKManager().cancelCheque(chequeId: requestValues.chequeId)
        switch result {
        case .success:
            return .ok()
        case .failure(let error):
            return .error(.init(error.localizedDescription))
        }
    }
}

extension RemoveChequeUseCase: RemoveChequeUseCaseProtocol {}

struct RemoveChequeUseCaseInput {
    let chequeId: Int
}

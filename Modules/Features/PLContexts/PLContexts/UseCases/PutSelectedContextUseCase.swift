//
//  PutSelectedContextUseCase.swift
//  PLContexts
//
//  Created by Ernesto Fernandez Calles on 23/12/21.
//

import CoreFoundationLib
import CoreFoundationLib
import SANPLLibrary

public protocol PutSelectedContextUseCaseProtocol: UseCase<PutSelectedContextUseCaseInput, Void, StringErrorOutput> {}

final class PutSelectedContextUseCase: UseCase<PutSelectedContextUseCaseInput, Void, StringErrorOutput> {
    var dependenciesResolver: DependenciesResolver
    var bsanDataProvider: BSANDataProvider
    
    public init(dependenciesResolver: DependenciesResolver, bsanDataProvider: BSANDataProvider) {
        self.dependenciesResolver = dependenciesResolver
        self.bsanDataProvider = bsanDataProvider
    }
    
    public override func executeUseCase(requestValues: PutSelectedContextUseCaseInput) throws -> UseCaseResponse<Void, StringErrorOutput> {
        let provider = self.dependenciesResolver.resolve(for: PLManagersProviderProtocol.self).getCustomerManager()
        let result = try provider.putActiveContext(ownerId: requestValues.ownerId)
        switch result {
        case .success(_):
            return .ok()
        case .failure(let error):
            return .error(StringErrorOutput(error.localizedDescription))
        }
    }
}

public struct PutSelectedContextUseCaseInput {
    let ownerId: String
}

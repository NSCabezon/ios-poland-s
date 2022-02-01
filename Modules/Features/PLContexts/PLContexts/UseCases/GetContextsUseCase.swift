//
//  GetContextsUseCase.swift
//  PLUI
//
//  Created by Ernesto Fernandez Calles on 23/12/21.
//

import CoreFoundationLib
import SANPLLibrary

public protocol GetContextsUseCaseProtocol: UseCase<Void, GetContextsUseCaseOkOutput, StringErrorOutput> {}

final class GetContextsUseCase: UseCase<Void, GetContextsUseCaseOkOutput, StringErrorOutput> {
    var dependenciesResolver: DependenciesResolver
    var bsanDataProvider: BSANDataProvider

    public init(dependenciesResolver: DependenciesResolver, bsanDataProvider: BSANDataProvider) {
        self.dependenciesResolver = dependenciesResolver
        self.bsanDataProvider = bsanDataProvider
    }

    public override func executeUseCase(requestValues: Void) throws -> UseCaseResponse<GetContextsUseCaseOkOutput, StringErrorOutput> {
        let customerContexts: [ContextDTO] = self.bsanDataProvider.getCustomerIndividual()?.customerContexts ?? []
        return .ok(GetContextsUseCaseOkOutput(contexts: customerContexts))
    }
}

public struct GetContextsUseCaseOkOutput {
    let contexts: [ContextDTO]
}

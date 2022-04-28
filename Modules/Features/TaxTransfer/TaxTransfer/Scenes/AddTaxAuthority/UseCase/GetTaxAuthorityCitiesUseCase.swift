//
//  GetTaxAuthorityCitiesUseCase.swift
//  TaxTransfer
//
//  Created by 185167 on 17/03/2022.
//

import Foundation
import CoreFoundationLib
import SANPLLibrary
import PLCommons

struct GetTaxAuthorityCitiesUseCaseInput {
    let taxTransferType: Int
}

struct GetTaxAuthorityCitiesUseCaseOkOutput {
    let taxAuthorityCities: [TaxAuthorityCity]
}

protocol GetTaxAuthorityCitiesUseCaseProtocol: UseCase<GetTaxAuthorityCitiesUseCaseInput, GetTaxAuthorityCitiesUseCaseOkOutput, StringErrorOutput> {}

final class GetTaxAuthorityCitiesUseCase: UseCase<GetTaxAuthorityCitiesUseCaseInput, GetTaxAuthorityCitiesUseCaseOkOutput, StringErrorOutput> {
    private let managersProvider: PLManagersProviderProtocol

    init(dependenciesResolver: DependenciesResolver) {
        self.managersProvider = dependenciesResolver.resolve(for: PLManagersProviderProtocol.self)
    }
    
    override func executeUseCase(requestValues: GetTaxAuthorityCitiesUseCaseInput) throws -> UseCaseResponse<GetTaxAuthorityCitiesUseCaseOkOutput, StringErrorOutput> {
        let queries = TaxAuthorityCitiesRequestQueries(taxTransferType: requestValues.taxTransferType)
        let result = try managersProvider.getTaxTransferManager().getTaxAuthorityCities(requestQueries: queries)
        switch result {
        case let .success(data):
            let output = GetTaxAuthorityCitiesUseCaseOkOutput(
                taxAuthorityCities: data.map { TaxAuthorityCity(cityName: $0) }
            )
            return .ok(output)
        case let .failure(error):
            return .error(.init(error.localizedDescription))
        }
    }
}

extension GetTaxAuthorityCitiesUseCase: GetTaxAuthorityCitiesUseCaseProtocol {}

//
//  GetPredefinedTaxAuthoritiesUseCase.swift
//  TaxTransfer
//
//  Created by 185167 on 03/02/2022.
//

import Commons
import Foundation
import CoreFoundationLib
import SANPLLibrary
import PLCommons

struct PredefinedTaxAuthoritiesUseCaseOkOutput {
    let taxAuthorities: [TaxAuthority]
}

protocol GetPredefinedTaxAuthoritiesUseCaseProtocol: UseCase<Void, PredefinedTaxAuthoritiesUseCaseOkOutput, StringErrorOutput> {}

final class GetPredefinedTaxAuthoritiesUseCase: UseCase<Void, PredefinedTaxAuthoritiesUseCaseOkOutput, StringErrorOutput> {
    private let managersProvider: PLManagersProviderProtocol
    private let mapper: TaxAuthorityMapping

    init(dependenciesResolver: DependenciesResolver) {
        self.managersProvider = dependenciesResolver.resolve(for: PLManagersProviderProtocol.self)
        self.mapper = dependenciesResolver.resolve(for: TaxAuthorityMapping.self)
    }
    
    override func executeUseCase(requestValues: Void) throws -> UseCaseResponse<PredefinedTaxAuthoritiesUseCaseOkOutput, StringErrorOutput> {
        let result = try managersProvider.getTaxTransferManager().getPredefinedTaxAuthorities()
        switch result {
        case let .success(data):
            let taxAuthorities = try data.map { try mapper.map($0) }
            let output = PredefinedTaxAuthoritiesUseCaseOkOutput(taxAuthorities: taxAuthorities)
            return .ok(output)
        case let .failure(error):
            return .error(.init(error.localizedDescription))
        }
    }
}

extension GetPredefinedTaxAuthoritiesUseCase: GetPredefinedTaxAuthoritiesUseCaseProtocol {}

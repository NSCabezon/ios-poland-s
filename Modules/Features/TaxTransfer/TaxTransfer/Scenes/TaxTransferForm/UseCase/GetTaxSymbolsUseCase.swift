//
//  GetTaxSymbolsUseCase.swift
//  TaxTransfer
//
//  Created by 185167 on 15/03/2022.
//

import Foundation
import CoreFoundationLib
import SANPLLibrary
import PLCommons

struct GetTaxSymbolsUseCaseOkOutput {
    let taxSymbols: [TaxSymbol]
}

protocol GetTaxSymbolsUseCaseProtocol: UseCase<Void, GetTaxSymbolsUseCaseOkOutput, StringErrorOutput> {}

final class GetTaxSymbolsUseCase: UseCase<Void, GetTaxSymbolsUseCaseOkOutput, StringErrorOutput> {
    private let managersProvider: PLManagersProviderProtocol
    private let mapper: TaxSymbolMapping

    init(dependenciesResolver: DependenciesResolver) {
        self.managersProvider = dependenciesResolver.resolve(for: PLManagersProviderProtocol.self)
        self.mapper = dependenciesResolver.resolve(for: TaxSymbolMapping.self)
    }
    
    override func executeUseCase(requestValues: Void) throws -> UseCaseResponse<GetTaxSymbolsUseCaseOkOutput, StringErrorOutput> {
        let result = try managersProvider.getTaxTransferManager().getTaxSymbols()
        switch result {
        case let .success(data):
            let taxSymbols = data.map { mapper.map($0) }
            let output = GetTaxSymbolsUseCaseOkOutput(taxSymbols: taxSymbols)
            return .ok(output)
        case let .failure(error):
            return .error(.init(error.localizedDescription))
        }
    }
}

extension GetTaxSymbolsUseCase: GetTaxSymbolsUseCaseProtocol {}

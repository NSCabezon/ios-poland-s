//
//  GetTaxPayersListUseCase.swift
//  TaxTransfer
//
//  Created by 187831 on 20/12/2021.
//

import CoreFoundationLib
import CoreFoundationLib
import SANPLLibrary

protocol GetTaxPayersListUseCaseProtocol: UseCase<Void, GetTaxPayersListOutput, StringErrorOutput> { }

final class GetTaxPayersListUseCase: UseCase<Void, GetTaxPayersListOutput, StringErrorOutput> {
    private let dependenciesResolver: DependenciesResolver
    
    private var mapper: TaxPayersMapping {
        return dependenciesResolver.resolve()
    }
    
    private var managersProvider: PLManagersProviderProtocol {
        return dependenciesResolver.resolve()
    }
    
    init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
    }
    
    override func executeUseCase(requestValues: Void) throws -> UseCaseResponse<GetTaxPayersListOutput, StringErrorOutput> {
        let result = try managersProvider.getTaxTransferManager().getPayers()
        switch result {
        case let .success(dtos):
            let taxPayers = dtos.map { mapper.map($0) }
            return .ok(
                GetTaxPayersListOutput(taxPayers: taxPayers)
            )
        case let .failure(error):
            return .error(.init(error.localizedDescription))
        }
    }
}

extension GetTaxPayersListUseCase: GetTaxPayersListUseCaseProtocol { }

struct GetTaxPayersListOutput {
    let taxPayers: [TaxPayer]
}

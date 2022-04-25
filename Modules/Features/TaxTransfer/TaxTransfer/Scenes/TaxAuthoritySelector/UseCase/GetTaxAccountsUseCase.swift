//
//  GetTaxAccountsUseCase.swift
//  TaxTransfer
//
//  Created by 185167 on 16/03/2022.
//

import Foundation
import CoreFoundationLib
import SANPLLibrary
import PLCommons

struct GetTaxAccountsUseCaseInput {
    let taxAccountNumberFilter: String?
    let taxAccountNameFilter: String?
    let cityFilter: String?
    let optionId: Int?
}

struct GetTaxAccountsUseCaseOkOutput {
    let taxAccounts: [TaxAccount]
}

protocol GetTaxAccountsUseCaseProtocol: UseCase<GetTaxAccountsUseCaseInput, GetTaxAccountsUseCaseOkOutput, StringErrorOutput> {}

final class GetTaxAccountsUseCase: UseCase<GetTaxAccountsUseCaseInput, GetTaxAccountsUseCaseOkOutput, StringErrorOutput> {
    private let managersProvider: PLManagersProviderProtocol
    private let mapper: TaxAccountMapping

    init(dependenciesResolver: DependenciesResolver) {
        self.managersProvider = dependenciesResolver.resolve(for: PLManagersProviderProtocol.self)
        self.mapper = dependenciesResolver.resolve(for: TaxAccountMapping.self)
    }
    
    override func executeUseCase(requestValues: GetTaxAccountsUseCaseInput) throws -> UseCaseResponse<GetTaxAccountsUseCaseOkOutput, StringErrorOutput> {
        let queries = TaxAccountsRequestQueries(
            accountNumber: requestValues.taxAccountNumberFilter,
            accountName: requestValues.taxAccountNameFilter,
            city: requestValues.cityFilter,
            optionId: requestValues.optionId
        )
        let result = try managersProvider.getTaxTransferManager().getTaxAccounts(requestQueries: queries)
        switch result {
        case let .success(data):
            let output = GetTaxAccountsUseCaseOkOutput(
                taxAccounts: try data.map { try mapper.map($0) }
            )
            return .ok(output)
        case let .failure(error):
            return .error(.init(error.localizedDescription))
        }
    }
}

extension GetTaxAccountsUseCase: GetTaxAccountsUseCaseProtocol {}

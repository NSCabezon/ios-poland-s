//
//  GetUserTaxAccountUseCase.swift
//  TaxTransfer
//
//  Created by 185167 on 12/04/2022.
//

import CoreFoundationLib
import SANPLLibrary
import PLCommons

struct GetUserTaxAccountUseCaseInput {
    let accountNumber: String
    let systemId: Int
}

struct GetUserTaxAccountUseCaseOkOutput {
    let userTaxAccount: UserTaxAccount
}

protocol GetUserTaxAccountUseCaseProtocol: UseCase<GetUserTaxAccountUseCaseInput, GetUserTaxAccountUseCaseOkOutput, StringErrorOutput> {}

final class GetUserTaxAccountUseCase: UseCase<GetUserTaxAccountUseCaseInput, GetUserTaxAccountUseCaseOkOutput, StringErrorOutput> {
    private let managersProvider: PLManagersProviderProtocol
    private let accountMapper: UserTaxAccountMapping

    init(dependenciesResolver: DependenciesResolver) {
        self.managersProvider = dependenciesResolver.resolve(for: PLManagersProviderProtocol.self)
        self.accountMapper = dependenciesResolver.resolve(for: UserTaxAccountMapping.self)
    }
    
    override func executeUseCase(requestValues: GetUserTaxAccountUseCaseInput) throws -> UseCaseResponse<GetUserTaxAccountUseCaseOkOutput, StringErrorOutput> {
        let queries = UserTaxAccountRequestQueries(
            accountNumber: requestValues.accountNumber,
            systemId: requestValues.systemId
        )
        let result = try managersProvider.getTaxTransferManager().getUserTaxAccount(requestQueries: queries)
        switch result {
        case let .success(data):
            do {
                let account = try accountMapper.map(data)
                let output = GetUserTaxAccountUseCaseOkOutput(userTaxAccount: account)
                return .ok(output)
            } catch {
                return .error(.init(error.localizedDescription))
            }
        case let .failure(error):
            return .error(.init(error.localizedDescription))
        }
    }
}

extension GetUserTaxAccountUseCase: GetUserTaxAccountUseCaseProtocol {}

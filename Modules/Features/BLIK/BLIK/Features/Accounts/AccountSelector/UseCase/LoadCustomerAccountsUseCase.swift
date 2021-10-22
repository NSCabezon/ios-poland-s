import Commons
import Foundation
import DomainCommon
import SANPLLibrary
import PLCommons
import PLCommonOperatives

protocol LoadCustomerAccountsUseCaseProtocol: UseCase<Void, LoadCustomerAccountsUseCaseOutput, StringErrorOutput> {}

final class LoadCustomerAccountsUseCase: UseCase<Void, LoadCustomerAccountsUseCaseOutput, StringErrorOutput> {
    private let dependenciesResolver: DependenciesResolver

    init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
    }
    
    override func executeUseCase(requestValues: Void) throws -> UseCaseResponse<LoadCustomerAccountsUseCaseOutput, StringErrorOutput> {
        let managersProvider: PLManagersProviderProtocol = dependenciesResolver.resolve(
            for: PLManagersProviderProtocol.self
        )
        let mapper: AccountForDebitMapping =
            dependenciesResolver.resolve(
                for: AccountForDebitMapping.self
            )
        let result = try managersProvider.getBLIKManager().getAccounts()
        switch result {
        case .success(let data):
            let customerAccounts = try data.map { try mapper.map(dto: $0) }
            return .ok(
                LoadCustomerAccountsUseCaseOutput(
                    accountsForDebit: customerAccounts
                )
            )
        case .failure(let error):
            return .error(.init(error.localizedDescription))
        }
    }
}

extension LoadCustomerAccountsUseCase: LoadCustomerAccountsUseCaseProtocol {}

struct LoadCustomerAccountsUseCaseOutput {
    let accountsForDebit: [AccountForDebit]
}

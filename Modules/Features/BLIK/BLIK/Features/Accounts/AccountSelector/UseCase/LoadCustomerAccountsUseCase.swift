import CoreFoundationLib
import Foundation
import CoreFoundationLib
import SANPLLibrary
import PLCommons
import PLCommonOperatives

protocol LoadCustomerAccountsUseCaseProtocol: UseCase<Void, LoadCustomerAccountsUseCaseOutput, StringErrorOutput> {}

final class LoadCustomerAccountsUseCase: UseCase<Void, LoadCustomerAccountsUseCaseOutput, StringErrorOutput> {
    private let dependenciesResolver: DependenciesResolver
    private var managersProvider: PLManagersProviderProtocol {
        dependenciesResolver.resolve()
    }
    private var accountMapper: BlikCustomerAccountMapping {
        dependenciesResolver.resolve()
    }

    init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
    }
    
    override func executeUseCase(requestValues: Void) throws -> UseCaseResponse<LoadCustomerAccountsUseCaseOutput, StringErrorOutput> {
        let result = try managersProvider.getBLIKManager().getAccounts()
        switch result {
        case .success(let data):
            let customerAccounts = data.map { accountMapper.map(dto: $0) }
            return .ok(
                LoadCustomerAccountsUseCaseOutput(accounts: customerAccounts)
            )
        case .failure(let error):
            return .error(.init(error.localizedDescription))
        }
    }
}

extension LoadCustomerAccountsUseCase: LoadCustomerAccountsUseCaseProtocol {}

struct LoadCustomerAccountsUseCaseOutput {
    let accounts: [BlikCustomerAccount]
}

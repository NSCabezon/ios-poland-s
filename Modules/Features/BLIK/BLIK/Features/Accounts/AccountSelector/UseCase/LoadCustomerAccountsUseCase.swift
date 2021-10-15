import Commons
import Foundation
import DomainCommon
import SANPLLibrary
import PLCommons

protocol LoadCustomerAccountsUseCaseProtocol: UseCase<Void, [AccountForDebit], StringErrorOutput> {}

final class LoadCustomerAccountsUseCase: UseCase<Void, [AccountForDebit], StringErrorOutput> {
    private let managersProvider: PLManagersProviderProtocol
    private let mapper: AccountForDebitMapping
    
    init(
        managersProvider: PLManagersProviderProtocol,
        mapper: AccountForDebitMapping = AccountForDebitMapper()
    ) {
        self.managersProvider = managersProvider
        self.mapper = mapper
    }
    
    override func executeUseCase(requestValues: Void) throws -> UseCaseResponse<[AccountForDebit], StringErrorOutput> {
        let result = try managersProvider.getBLIKManager().getAccounts()
        switch result {
        case .success(let data):
            let customerAccounts = try data.map { try mapper.map(dto: $0) }
            return .ok(customerAccounts)
        case .failure(let error):
            return .error(.init(error.localizedDescription))
        }
    }
}

extension LoadCustomerAccountsUseCase: LoadCustomerAccountsUseCaseProtocol {}

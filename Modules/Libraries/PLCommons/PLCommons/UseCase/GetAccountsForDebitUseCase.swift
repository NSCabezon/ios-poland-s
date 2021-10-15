import Commons
import Foundation
import DomainCommon
import SANPLLibrary

public protocol GetAccountsForDebitProtocol: UseCase<Void, [AccountForDebit], StringErrorOutput> {}

public final class GetAccountsForDebitUseCase: UseCase<Void, [AccountForDebit], StringErrorOutput> {
    
    public enum TransactionType: Int {
        case mobileTransfer = 33
        case charityTransfer = 16
    }
    
    private let managersProvider: PLManagersProviderProtocol
    private let mapper: AccountForDebitMapping
    private let transactionType: TransactionType

    public init(transactionType: TransactionType,
                dependenciesResolver: DependenciesResolver,
                mapper: AccountForDebitMapping = AccountForDebitMapper()) {
        self.managersProvider = dependenciesResolver.resolve(for: PLManagersProviderProtocol.self)
        self.mapper = mapper
        self.transactionType = transactionType
    }
    
    public override func executeUseCase(requestValues: Void) throws -> UseCaseResponse<[AccountForDebit], StringErrorOutput> {
        let result = try managersProvider.getAccountsManager().getAccountsForDebit(transactionType: transactionType.rawValue)
        switch result {
        case .success(let data):
            let customerAccounts = try data.map { try mapper.map(dto: $0) }
            return .ok(customerAccounts)
        case .failure(let error):
            return .error(.init(error.localizedDescription))
        }
    }
}

extension GetAccountsForDebitUseCase: GetAccountsForDebitProtocol {}

import CoreFoundationLib
import Foundation
import SANPLLibrary

protocol SetTransactionsLimitUseCaseProtocol: UseCase<SetTransactionsLimitUseCaseInput, Void, StringErrorOutput> {}

final class SetTransactionsLimitUseCase: UseCase<SetTransactionsLimitUseCaseInput, Void, StringErrorOutput> {
    private let dependenciesResolver: DependenciesResolver
    
    init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
    }
    
    override func executeUseCase(requestValues: SetTransactionsLimitUseCaseInput) throws -> UseCaseResponse<Void, StringErrorOutput> {
        let managersProvider: PLManagersProviderProtocol = dependenciesResolver.resolve(
            for: PLManagersProviderProtocol.self
        )
        let request = TransactionLimitRequestDTO(
            shopLimits: TransactionLimitRequestDTO.Limits(
                trnLimit: requestValues.transactionLimit.purchaseLimit,
                cycleLimit: requestValues.transactionLimit.purchaseLimit
            ),
            cashLimits: TransactionLimitRequestDTO.Limits(
                trnLimit: requestValues.transactionLimit.withdrawLimit,
                cycleLimit: requestValues.transactionLimit.withdrawLimit
            )
        )
        let result = try managersProvider.getBLIKManager().setTransactionLimits(request)
        switch result {
        case .success():
            return .ok()
        case .failure(let error):
            return .error(.init(error.localizedDescription))
        }
    }
}

extension SetTransactionsLimitUseCase: SetTransactionsLimitUseCaseProtocol {}

struct SetTransactionsLimitUseCaseInput {
    let transactionLimit: TransactionLimitModel
}

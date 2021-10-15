import Commons
import Foundation
import DomainCommon
import SANPLLibrary

protocol SetTransactionsLimitUseCaseProtocol: UseCase<TransactionLimitModel, Void, StringErrorOutput> {}

final class SetTransactionsLimitUseCase: UseCase<TransactionLimitModel, Void, StringErrorOutput> {
    private let managersProvider: PLManagersProviderProtocol
    
    init(
        managersProvider: PLManagersProviderProtocol
    ) {
        self.managersProvider = managersProvider
    }
    
    override func executeUseCase(requestValues: TransactionLimitModel) throws -> UseCaseResponse<Void, StringErrorOutput> {
        let request = TransactionLimitRequestDTO(
            shopLimits: TransactionLimitRequestDTO.Limits(
                trnLimit: requestValues.purchaseLimit,
                cycleLimit: requestValues.purchaseLimit
            ),
            cashLimits: TransactionLimitRequestDTO.Limits(
                trnLimit: requestValues.withdrawLimit,
                cycleLimit: requestValues.withdrawLimit
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

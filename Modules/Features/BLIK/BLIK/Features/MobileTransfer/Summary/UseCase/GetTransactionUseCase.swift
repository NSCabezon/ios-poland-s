import Foundation
import Models
import Commons
import DomainCommon
import SANPLLibrary
import SANLegacyLibrary

protocol GetTransactionUseCaseProtocol: UseCase<Void, MobileTransferSummaryViewModel, StringErrorOutput> {}

final class GetTransactionUseCase: UseCase<Void, MobileTransferSummaryViewModel, StringErrorOutput> {
    private let managersProvider: PLManagersProviderProtocol
    private let mapper: MobileTransferSummaryViewModelMapping
    
    init(dependenciesResolver: DependenciesResolver) {
        self.managersProvider = dependenciesResolver.resolve(for: PLManagersProviderProtocol.self)
        self.mapper = dependenciesResolver.resolve(for: MobileTransferSummaryViewModelMapping.self)
    }
    
    override func executeUseCase(requestValues: Void) throws -> UseCaseResponse<MobileTransferSummaryViewModel, StringErrorOutput> {
        let result = try managersProvider
            .getBLIKManager()
            .getTransactions()

        switch result {
        case .success(let result):
            return .ok(mapper.map(transaction: result))
        case .failure(let error):
            let errorBody: ErrorDTO? = error.getErrorBody()

            guard errorBody?.errorCode1 == .customerTypeDisabled,
                  let errorType = errorBody?.errorCode2 else {
                return .error(.init(nil))
            }

            return .error(.init(errorType.errorKey))
        }
    }
}

extension GetTransactionUseCase: GetTransactionUseCaseProtocol {}

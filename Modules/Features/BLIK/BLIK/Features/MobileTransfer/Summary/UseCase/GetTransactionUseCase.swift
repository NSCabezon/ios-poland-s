import Foundation
import CoreFoundationLib
import Commons
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
            let blikError = BlikError(with: error.getErrorBody())
            guard let blikError = blikError,
                  blikError.errorCode1 == .customerTypeDisabled else {
                return .error(.init(error.localizedDescription))
            }
            return .error(.init(blikError.errorKey))
        }
    }
}

extension GetTransactionUseCase: GetTransactionUseCaseProtocol {}

import Commons
import Foundation
import DomainCommon
import SANPLLibrary

protocol AcceptBLIKTransactionProtocol: UseCase<AcceptBLIKTransactionUseCaseInput, Void, StringErrorOutput> {}

final class AcceptBLIKTransactionUseCase: UseCase<AcceptBLIKTransactionUseCaseInput, Void, StringErrorOutput> {
    
    private let managersProvider: PLManagersProviderProtocol

    init(dependenciesResolver: DependenciesResolver) {
        self.managersProvider = dependenciesResolver.resolve(for: PLManagersProviderProtocol.self)
    }
    
    override func executeUseCase(requestValues: AcceptBLIKTransactionUseCaseInput) throws -> UseCaseResponse<Void, StringErrorOutput> {
        
        let result = try managersProvider
            .getBLIKManager()
            .acceptTransaction(trnId: requestValues.trnId,
                               trnDate: requestValues.trnDate)
        switch result {
        case .success:
            return .ok()
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

extension AcceptBLIKTransactionUseCase: AcceptBLIKTransactionProtocol {}


struct AcceptBLIKTransactionUseCaseInput {
    let trnId: Int
    let trnDate: String
}

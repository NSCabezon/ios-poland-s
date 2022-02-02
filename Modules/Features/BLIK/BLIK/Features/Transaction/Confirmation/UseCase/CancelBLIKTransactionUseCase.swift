import CoreFoundationLib
import Foundation
import SANPLLibrary

protocol CancelBLIKTransactionProtocol: UseCase<CancelBLIKTransactionUseCaseInput, Void, StringErrorOutput> {}

final class CancelBLIKTransactionUseCase: UseCase<CancelBLIKTransactionUseCaseInput, Void, StringErrorOutput> {
    
    private let managersProvider: PLManagersProviderProtocol

    init(dependenciesResolver: DependenciesResolver) {
        self.managersProvider = dependenciesResolver.resolve(for: PLManagersProviderProtocol.self)
    }
    
    override func executeUseCase(requestValues: CancelBLIKTransactionUseCaseInput) throws -> UseCaseResponse<Void, StringErrorOutput> {
        
        let request = CancelBLIKTransactionRequestDTO(transactionDate: requestValues.trnDate, confirmFlag: requestValues.confirmFlag)
        let result = try managersProvider.getBLIKManager().cancelTransaction(request: request,
                                                                             trnId: requestValues.trnId)

        switch result {
        case .success:
            return .ok()
        case .failure(let error):
            let blikError = BlikError(with: error.getErrorBody())
            guard blikError?.errorCode1 == .customerTypeDisabled,
                  blikError?.errorCode2 == .errPosting else {
                return .error(.init(error.localizedDescription))
            }
         
            return .ok()
        }
    }
}

extension CancelBLIKTransactionUseCase: CancelBLIKTransactionProtocol {}


struct CancelBLIKTransactionUseCaseInput {
    let trnId: Int
    let trnDate: String
    let cancelType: CancelType
    
    var confirmFlag: CancelBLIKTransactionRequestDTO.ConfirmFlag {
        switch cancelType {
        case .exit:
            return .reject
        case .timeout:
            return .timeout
        }
    }
}

import Commons
import Foundation
import DomainCommon
import SANPLLibrary

enum GetTrnToConfErrorResult: String {
    case watchStatus
    case endProcess
}

protocol GetTrnToConfProtocol: UseCase<Void, GetTrnToConfUseCaseOkOutput, StringErrorOutput> {}

final class GetTrnToConfUseCase: UseCase<Void, GetTrnToConfUseCaseOkOutput, StringErrorOutput> {
    private let dependenciesResolver: DependenciesResolver
    private let managersProvider: PLManagersProviderProtocol
    
    init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
        self.managersProvider = dependenciesResolver.resolve(for: PLManagersProviderProtocol.self)
    }
    
    override func executeUseCase(requestValues: Void) throws -> UseCaseResponse<GetTrnToConfUseCaseOkOutput, StringErrorOutput> {
        let result = try managersProvider.getBLIKManager().getTrnToConf()
        switch result {
        case .success(let transaction):
            return .ok(GetTrnToConfUseCaseOkOutput(transaction: transaction))
        case .failure(let error):
            let errorCode = error.getErrorCode()
            let errorBody: ErrorDTO? = error.getErrorBody()
            
            let shouldWatchStatus = errorCode == 510
                && errorBody?.errorCode1 == .customerTypeDisabled
                && errorBody?.errorCode2 == .noTrnToConf
            let errorStatus: GetTrnToConfErrorResult = shouldWatchStatus ? .watchStatus : .endProcess

            return .error(.init(errorStatus.rawValue))
        }
    }
}

extension GetTrnToConfUseCase: GetTrnToConfProtocol {}

struct GetTrnToConfUseCaseOkOutput {
    let transaction: GetTrnToConfDTO
}

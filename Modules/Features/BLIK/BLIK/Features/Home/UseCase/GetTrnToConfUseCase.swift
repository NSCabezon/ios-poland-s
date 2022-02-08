import CoreFoundationLib
import Foundation
import SANPLLibrary

enum GetTrnToConfErrorResult: String {
    case watchStatus
    case endProcess
    case noConnection
}

protocol GetTrnToConfProtocol: UseCase<Void, GetTrnToConfUseCaseOkOutput, StringErrorOutput> {}

final class GetTrnToConfUseCase: UseCase<Void, GetTrnToConfUseCaseOkOutput, StringErrorOutput> {
    private let dependenciesResolver: DependenciesResolver
    
    init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
    }
    
    override func executeUseCase(requestValues: Void) throws -> UseCaseResponse<GetTrnToConfUseCaseOkOutput, StringErrorOutput> {
        let managersProvider: PLManagersProviderProtocol = dependenciesResolver.resolve(for: PLManagersProviderProtocol.self)
        let result = try managersProvider.getBLIKManager().getTrnToConf()
        switch result {
        case .success(let transaction):
            return .ok(GetTrnToConfUseCaseOkOutput(transaction: transaction))
        case .failure(let error):
            switch error {
            case .noConnection:
                return .error(.init(GetTrnToConfErrorResult.noConnection.rawValue))
            default:
                let errorCode = error.getErrorCode()
                let blikError = BlikError(with: error.getErrorBody())
                let shouldWatchStatus = errorCode == 510
                    && blikError?.errorCode1 == .customerTypeDisabled
                    && blikError?.errorCode2 == .noTrnToConf
                let errorStatus: GetTrnToConfErrorResult = shouldWatchStatus ? .watchStatus : .endProcess
                return .error(.init(errorStatus.rawValue))
            }
        }
    }
}

extension GetTrnToConfUseCase: GetTrnToConfProtocol {}

struct GetTrnToConfUseCaseOkOutput {
    let transaction: GetTrnToConfDTO
}

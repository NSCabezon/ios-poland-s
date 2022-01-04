import Foundation
import CoreFoundationLib
import Commons
import SANPLLibrary
import SANLegacyLibrary
import PLCommons

protocol GetIndividualProtocol: UseCase<Void, GetIndividualUseCaseOkOutput, StringErrorOutput> {}

final class GetIndividualUseCase: UseCase<Void, GetIndividualUseCaseOkOutput, StringErrorOutput> {
    
    private let managersProvider: PLManagersProviderProtocol
    
    init(dependencyResolver: DependenciesResolver) {
        self.managersProvider = dependencyResolver.resolve(for: PLManagersProviderProtocol.self)
    }
    
    override func executeUseCase(requestValues: Void) throws -> UseCaseResponse<GetIndividualUseCaseOkOutput, StringErrorOutput> {
        let result = try managersProvider
            .getCustomerManager()
            .getIndividual()
        switch result {
        case .success(let result):
            return .ok(.init(customer: result))
        case .failure(let error):
            let blikError = BlikError(with: error.getErrorBody())
            guard blikError?.errorCode1 == .customerTypeDisabled else {
                return .error(.init(nil))
            }
            return .error(.init(blikError?.errorKey))
        }
    }
}

extension GetIndividualUseCase: GetIndividualProtocol {}

struct GetIndividualUseCaseOkOutput {
    let customer: CustomerDTO
}

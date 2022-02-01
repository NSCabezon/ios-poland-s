import Foundation
import CoreFoundationLib
import SANPLLibrary

final class GetAccountsUseCase: UseCase<Void, GetAccountsUseCaseOkOutput, StringErrorOutput> {
    private let dependenciesResolver: DependenciesResolver
    
    init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
    }
    
    override func executeUseCase(requestValues: Void) throws -> UseCaseResponse<GetAccountsUseCaseOkOutput, StringErrorOutput> {
        let plManagersProvider = dependenciesResolver.resolve(for: PLManagersProviderProtocol.self)
        let manager = plManagersProvider.getCreditCardRepaymentManager()
        let result = try manager.getAccountsForDebit()
        
        let accounts: [CCRAccountEntity]
        switch result {
        case let .success(dtos):
            accounts = dtos
                .filter { $0.type == .PERSONAL || $0.type == .SAVINGS }
                .compactMap(CCRAccountEntity.mapAccountFromDTO)
        case .failure(let error):
            return .error(.init(error.localizedDescription))
        }
        
        let response = GetAccountsUseCaseOkOutput(accounts: accounts)
        return .ok(response)
    }
}

struct GetAccountsUseCaseOkOutput {
    let accounts: [CCRAccountEntity]
}

import CoreFoundationLib
import os
import SANPLLibrary

protocol GetLastTransactionProtocol: UseCase<Void, GetLastTransactionUseCaseOkOutput, StringErrorOutput> {}

final class GetLastTransactionUseCase: UseCase<Void, GetLastTransactionUseCaseOkOutput, StringErrorOutput> {
    private let dependenciesResolver: DependenciesResolver
    private let managersProvider: PLManagersProviderProtocol
    
    init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
        self.managersProvider = dependenciesResolver.resolve(for: PLManagersProviderProtocol.self)
    }
    
    override func executeUseCase(requestValues: Void) throws -> UseCaseResponse<GetLastTransactionUseCaseOkOutput, StringErrorOutput> {
        let result = try managersProvider.getQuickBalanceManager().getQuickBalanceLastTransaction()
        switch result {
        case .success(let lastTransaction):
            return responseFor(lastTransaction: lastTransaction)
        case .failure(let error):
            return .error(.init(error.localizedDescription))
        }
    }
    
    private func responseFor(lastTransaction: PLQuickBalanceDTO) -> UseCaseResponse<GetLastTransactionUseCaseOkOutput, StringErrorOutput> {
        return .ok(
            GetLastTransactionUseCaseOkOutput(lastTransaction: lastTransaction)
        )
    }
}

extension GetLastTransactionUseCase: GetLastTransactionProtocol {}

struct GetLastTransactionUseCaseOkOutput {
    let dto: PLQuickBalanceDTO
    
    init(lastTransaction: PLQuickBalanceDTO) {
        self.dto = lastTransaction
    }
}

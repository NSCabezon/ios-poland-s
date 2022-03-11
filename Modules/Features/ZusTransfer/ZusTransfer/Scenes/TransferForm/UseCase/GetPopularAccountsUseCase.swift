import CoreFoundationLib
import SANPLLibrary
import PLCommons

protocol GetPopularAccountsUseCaseProtocol: UseCase<GetPopularAccountsUseCaseInput, GetPopularAccountsUseCaseOutput, StringErrorOutput> { }

final class GetPopularAccountsUseCase: UseCase<GetPopularAccountsUseCaseInput, GetPopularAccountsUseCaseOutput, StringErrorOutput> {
    
    private let dependenciesResolver: DependenciesResolver
    private let managersProvider: PLManagersProviderProtocol
    
    init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
        managersProvider = dependenciesResolver.resolve(for: PLManagersProviderProtocol.self)
    }
    
    override func executeUseCase(requestValues: GetPopularAccountsUseCaseInput) throws -> UseCaseResponse<GetPopularAccountsUseCaseOutput, StringErrorOutput> {
        let result = try managersProvider.getAccountsManager().getExternalPolular(accountType: requestValues.accountType)
        switch result {
        case let .success(accounts):
            let numbers =  accounts.compactMap({ PopularAccountNumber(number: $0.number) })
            let output = GetPopularAccountsUseCaseOutput(numbers: numbers)
            return  .ok(output)
        case let .failure(error):
            return .error(.init(error.localizedDescription))
        }
    }
}

extension GetPopularAccountsUseCase: GetPopularAccountsUseCaseProtocol { }

struct GetPopularAccountsUseCaseInput {
    let accountType: Int
}

struct GetPopularAccountsUseCaseOutput {
    let numbers: [PopularAccountNumber]
}

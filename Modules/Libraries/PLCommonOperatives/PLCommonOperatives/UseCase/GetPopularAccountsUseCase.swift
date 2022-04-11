import CoreFoundationLib
import SANPLLibrary
import PLCommons

public protocol GetPopularAccountsUseCaseProtocol: UseCase<GetPopularAccountsUseCaseInput, GetPopularAccountsUseCaseOutput, StringErrorOutput> { }

public final class GetPopularAccountsUseCase: UseCase<GetPopularAccountsUseCaseInput, GetPopularAccountsUseCaseOutput, StringErrorOutput> {
    
    private let dependenciesResolver: DependenciesResolver
    private let managersProvider: PLManagersProviderProtocol
    
    public init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
        managersProvider = dependenciesResolver.resolve(for: PLManagersProviderProtocol.self)
    }
    
    public override func executeUseCase(requestValues: GetPopularAccountsUseCaseInput) throws -> UseCaseResponse<GetPopularAccountsUseCaseOutput, StringErrorOutput> {
        let result = try managersProvider.getAccountsManager().getExternalPopular(accountType: requestValues.accountType)
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

public struct GetPopularAccountsUseCaseInput {
    let accountType: Int
    
    public init(accountType: Int) {
        self.accountType = accountType
    }
}

public struct GetPopularAccountsUseCaseOutput {
    public let numbers: [PopularAccountNumber]
}

import CoreFoundationLib
import SANPLLibrary
import PLCommons

protocol GetRecipientsUseCaseProtocol: UseCase<GetRecipientsUseCaseInput, GetRecipientsUseCaseOutput, StringErrorOutput> { }

final class GetRecipientsUseCase: UseCase<GetRecipientsUseCaseInput, GetRecipientsUseCaseOutput, StringErrorOutput> {
    
    private enum TransferType: String {
        case ELIXIR
    }
    
    private let dependenciesResolver: DependenciesResolver
    private let mapper: RecipientMapping
    private let managersProvider: PLManagersProviderProtocol
    
    init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
        mapper = dependenciesResolver.resolve(for: RecipientMapping.self)
        managersProvider = dependenciesResolver.resolve(for: PLManagersProviderProtocol.self)
    }
    
    override func executeUseCase(requestValues: GetRecipientsUseCaseInput) throws -> UseCaseResponse<GetRecipientsUseCaseOutput, StringErrorOutput> {
        let parameters = GetPayeesParameters(recCunt: nil, getOptions: nil)
        let result = try managersProvider.getTransferManager().getPayees(parameters)
        switch result {
        case let .success(payees):
            let recipients = mapper.map(with: payees)
            let output = GetRecipientsUseCaseOutput(recipients: recipients)
            return  .ok(output)
        case let .failure(error):
            return .error(.init(error.localizedDescription))
        }
    }
}

extension GetRecipientsUseCase: GetRecipientsUseCaseProtocol { }

struct GetRecipientsUseCaseInput {
    
}

struct GetRecipientsUseCaseOutput {
    let recipients: [Recipient]
}

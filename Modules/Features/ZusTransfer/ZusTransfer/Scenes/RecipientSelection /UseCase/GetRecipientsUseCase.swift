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
        let parameters = GetPayeesParameters(recCunt: nil, getOptions: 24)
        let result = try managersProvider.getTransferManager().getPayees(parameters)
        switch result {
        case let .success(payees):
            let recipients =  mapper.map(
                with: payees.filter {
                    guard let transferType = $0.account?.transferType else { return false }
                    let isCorrectType = transferType == TransferType.ELIXIR.rawValue
                    let accountNrb = IBANFormatter.formatIbanToNrb(for: $0.account?.accountNo)
                    guard !accountNrb.isEmpty, accountNrb.count == 26 else { return false }
                    let accountSubstring = accountNrb.substring(2, 13)
                    let isCorrectAccount = accountSubstring == requestValues.maskAccount
                    return isCorrectType && isCorrectAccount
                }
            )
            let output = GetRecipientsUseCaseOutput(recipients: recipients)
            return  .ok(output)
        case let .failure(error):
            return .error(.init(error.localizedDescription))
        }
    }
}

extension GetRecipientsUseCase: GetRecipientsUseCaseProtocol { }

struct GetRecipientsUseCaseInput {
    let maskAccount: String
}

struct GetRecipientsUseCaseOutput {
    let recipients: [Recipient]
}

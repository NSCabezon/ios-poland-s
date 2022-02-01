import Foundation
import CoreFoundationLib
import SANPLLibrary
import SANLegacyLibrary
import PLCommons

enum AcceptCharityTransactionErrorResult: String {
    case noConnection
    case limitExceeded
    case insufficientFunds
    case generalErrorMessages
}

protocol AcceptCharityTransactionProtocol: UseCase<AcceptCharityTransactionUseCaseInput, AcceptCharityTransactionUseCaseOkOutput, StringErrorOutput> {}

final class AcceptCharityTransactionUseCase: UseCase<AcceptCharityTransactionUseCaseInput, AcceptCharityTransactionUseCaseOkOutput, StringErrorOutput> {
    private let managersProvider: PLManagersProviderProtocol
    private let charityTransferSummaryMapper: CharityTransferSummaryMapping
    private let charityTransferSendMoneyInputMapper: CharityTransferSendMoneyInputMapping
    
    init(dependenciesResolver: DependenciesResolver) {
        self.managersProvider = dependenciesResolver.resolve(for: PLManagersProviderProtocol.self)
        self.charityTransferSummaryMapper = dependenciesResolver.resolve(for: CharityTransferSummaryMapping.self)
        self.charityTransferSendMoneyInputMapper = dependenciesResolver.resolve(for: CharityTransferSendMoneyInputMapping.self)
    }
    
    override func executeUseCase(requestValues: AcceptCharityTransactionUseCaseInput) throws -> UseCaseResponse<AcceptCharityTransactionUseCaseOkOutput, StringErrorOutput> {
        guard let userId = try? managersProvider.getLoginManager().getAuthCredentials().userId else {
            return .error(.init("userId not exists"))
        }
        let sendMoneyConfirmationInput = charityTransferSendMoneyInputMapper.map(with: requestValues, userId: userId)
        let result = try managersProvider.getTransferManager().sendConfirmation(sendMoneyConfirmationInput)
        
        switch result {
        case .success(let result):
            return .ok(.init(summary: charityTransferSummaryMapper.map(with: result)))
        case .failure(let error):
            return prepareErrorMessages(with: error)
        }
    }
    
    private func prepareErrorMessages(with error: NetworkProviderError) -> UseCaseResponse<AcceptCharityTransactionUseCaseOkOutput, StringErrorOutput> {
        switch error {
        case .noConnection:
            return .error(.init(AcceptCharityTransactionErrorResult.noConnection.rawValue))
        default:
            let charityTransferError = CharityTransferError(with: error.getErrorBody())
            return .error(.init(charityTransferError?.errorResult.rawValue))
        }
    }
}

extension AcceptCharityTransactionUseCase: AcceptCharityTransactionProtocol {}


struct AcceptCharityTransactionUseCaseInput {
    let model: CharityTransferModel
}

struct AcceptCharityTransactionUseCaseOkOutput {
    let summary: CharityTransferSummary
}

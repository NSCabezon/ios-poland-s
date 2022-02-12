import Foundation
import CoreFoundationLib
import SANPLLibrary
import SANLegacyLibrary
import PLCommons

enum AcceptZusTransactionErrorResult: String {
    case noConnection
    case limitExceeded
    case generalErrorMessages
    case accountOnBlacklist
    case expressEecipientInactive
}

protocol AcceptZusTransactionProtocol: UseCase<AcceptZusTransactionUseCaseInput, AcceptZusTransactionUseCaseOkOutput, StringErrorOutput> {}

final class AcceptZusTransactionUseCase: UseCase<AcceptZusTransactionUseCaseInput, AcceptZusTransactionUseCaseOkOutput, StringErrorOutput> {
    private let managersProvider: PLManagersProviderProtocol
    private let zusTransferSummaryMapper: ZusTransferSummaryMapping
    private let zusTransferSendMoneyInputMapper: ZusTransferSendMoneyInputMapping
    
    init(dependenciesResolver: DependenciesResolver) {
        self.managersProvider = dependenciesResolver.resolve(for: PLManagersProviderProtocol.self)
        self.zusTransferSummaryMapper = dependenciesResolver.resolve(for: ZusTransferSummaryMapping.self)
        self.zusTransferSendMoneyInputMapper = dependenciesResolver.resolve(for: ZusTransferSendMoneyInputMapping.self)
    }
    
    override func executeUseCase(requestValues: AcceptZusTransactionUseCaseInput) throws -> UseCaseResponse<AcceptZusTransactionUseCaseOkOutput, StringErrorOutput> {
        guard let userId = try? managersProvider.getLoginManager().getAuthCredentials().userId else {
            return .error(.init("userId not exists"))
        }
        let sendMoneyConfirmationInput = zusTransferSendMoneyInputMapper.map(with: requestValues, userId: userId)
        let result = try managersProvider.getTransferManager().sendConfirmation(sendMoneyConfirmationInput)
        
        switch result {
        case .success(let result):
            return .ok(.init(summary: zusTransferSummaryMapper.map(with: result)))
        case .failure(let error):
            return prepareErrorMessages(with: error)
        }
    }
    
    private func prepareErrorMessages(with error: NetworkProviderError) -> UseCaseResponse<AcceptZusTransactionUseCaseOkOutput, StringErrorOutput> {
        switch error {
        case .noConnection:
            return .error(.init(AcceptZusTransactionErrorResult.noConnection.rawValue))
        default:
            let zusTransferError = ZusTransferError(with: error.getErrorBody())
            return .error(.init(zusTransferError?.errorResult.rawValue))
        }
    }
}

extension AcceptZusTransactionUseCase: AcceptZusTransactionProtocol {}


struct AcceptZusTransactionUseCaseInput {
    let model: ZusTransferModel
}

struct AcceptZusTransactionUseCaseOkOutput {
    let summary: ZusTransferSummary
}

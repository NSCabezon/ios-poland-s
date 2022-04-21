import Foundation
import CoreFoundationLib
import SANPLLibrary
import SANLegacyLibrary
import PLCommons

enum AcceptZusSmeTransactionErrorResult: String {
    case noConnection
    case limitExceeded
    case generalErrorMessages
    case accountOnBlacklist
    case expressEecipientInactive
}

protocol AcceptZusSmeTransactionProtocol: UseCase<AcceptZusSmeTransactionUseCaseInput, AcceptZusSmeTransactionUseCaseOkOutput, StringErrorOutput> {}

final class AcceptZusSmeTransactionUseCase: UseCase<AcceptZusSmeTransactionUseCaseInput, AcceptZusSmeTransactionUseCaseOkOutput, StringErrorOutput> {
    private let managersProvider: PLManagersProviderProtocol
    private let zusTransferSummaryMapper: ZusSmeTransferSummaryMapping
    private let zusTransferSendMoneyInputMapper: ZusSmeTransferSendMoneyInputMapping
    
    init(dependenciesResolver: DependenciesResolver) {
        self.managersProvider = dependenciesResolver.resolve(for: PLManagersProviderProtocol.self)
        self.zusTransferSummaryMapper = dependenciesResolver.resolve(for: ZusSmeTransferSummaryMapping.self)
        self.zusTransferSendMoneyInputMapper = dependenciesResolver.resolve(for: ZusSmeTransferSendMoneyInputMapping.self)
    }
    
    override func executeUseCase(requestValues: AcceptZusSmeTransactionUseCaseInput) throws -> UseCaseResponse<AcceptZusSmeTransactionUseCaseOkOutput, StringErrorOutput> {
        guard let userId = try? managersProvider.getLoginManager().getAuthCredentials().userId else {
            return .error(.init("userId not exists"))
        }
        let sendMoneyConfirmationInput = zusTransferSendMoneyInputMapper.map(with: requestValues.model, userId: userId)
        let result = try managersProvider.getTransferManager().sendConfirmation(sendMoneyConfirmationInput)
        
        switch result {
        case .success(let result):
            return .ok(.init(summary: zusTransferSummaryMapper.map(with: result, transferModel: requestValues.model)))
        case .failure(let error):
            return prepareErrorMessages(with: error)
        }
    }
    
    private func prepareErrorMessages(with error: NetworkProviderError) -> UseCaseResponse<AcceptZusSmeTransactionUseCaseOkOutput, StringErrorOutput> {
        switch error {
        case .noConnection:
            return .error(.init(AcceptZusSmeTransactionErrorResult.noConnection.rawValue))
        default:
            let zusTransferError = ZusSmeTransferError(with: error.getErrorBody())
            return .error(.init(zusTransferError?.errorResult.rawValue))
        }
    }
}

extension AcceptZusSmeTransactionUseCase: AcceptZusSmeTransactionProtocol {}


struct AcceptZusSmeTransactionUseCaseInput {
    let model: ZusSmeTransferModel
}

struct AcceptZusSmeTransactionUseCaseOkOutput {
    let summary: ZusSmeSummaryModel
}

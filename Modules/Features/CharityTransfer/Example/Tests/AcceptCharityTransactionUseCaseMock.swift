import Foundation
import CoreFoundationLib
import SANPLLibrary
import SANLegacyLibrary
import PLCommons
@testable import CharityTransfer

final class AcceptCharityTransactionUseCaseMock: UseCase<AcceptCharityTransactionUseCaseInput, AcceptCharityTransactionUseCaseOkOutput, StringErrorOutput> {
    
    private let charityTransferSummaryMapper: CharityTransferSummaryMapping
    @DecodeFile(name: "setConfirmationResponse",
                bundle: Bundle(for: AcceptCharityTransactionUseCaseMock.self))
    private var confirmationTransferDTO: ConfirmationTransferDTO
    
    init(dependenciesResolver: DependenciesResolver) {
        self.charityTransferSummaryMapper = dependenciesResolver.resolve(for: CharityTransferSummaryMapping.self)
    }
    
    override func executeUseCase(requestValues: AcceptCharityTransactionUseCaseInput) throws -> UseCaseResponse<AcceptCharityTransactionUseCaseOkOutput, StringErrorOutput> {
        return .ok(.init(summary: charityTransferSummaryMapper.map(with: confirmationTransferDTO)))
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

extension AcceptCharityTransactionUseCaseMock: AcceptCharityTransactionProtocol {}


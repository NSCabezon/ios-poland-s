import PLCommons
import CoreFoundationLib
import PLCommonOperatives
@testable import ZusTransfer

final class AcceptZusTransactionUseCaseMock: UseCase<AcceptZusTransactionUseCaseInput, AcceptZusTransactionUseCaseOkOutput, StringErrorOutput>, AcceptZusTransactionProtocol {
        
    override func executeUseCase(requestValues: AcceptZusTransactionUseCaseInput) throws -> UseCaseResponse<AcceptZusTransactionUseCaseOkOutput, StringErrorOutput> {
        .ok(AcceptZusTransactionUseCaseOkOutput(summary: ZusTransferSummaryMock.getMock()))
    }
}

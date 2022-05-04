import PLCommons
import CoreFoundationLib
import PLCommonOperatives
@testable import ZusSMETransfer

final class AcceptZusSmeTransactionUseCaseMock: UseCase<AcceptZusSmeTransactionUseCaseInput, AcceptZusSmeTransactionUseCaseOkOutput, StringErrorOutput>, AcceptZusSmeTransactionProtocol {
        
    override func executeUseCase(requestValues: AcceptZusSmeTransactionUseCaseInput) throws -> UseCaseResponse<AcceptZusSmeTransactionUseCaseOkOutput, StringErrorOutput> {
        .ok(AcceptZusSmeTransactionUseCaseOkOutput(summary: ZusSmeSummaryModel.stub()))
    }
}

import Foundation
import PLCommons
import CoreFoundationLib
@testable import ZusTransfer

final class GetRecipientsUseCaseMock: UseCase<GetRecipientsUseCaseInput, GetRecipientsUseCaseOutput, StringErrorOutput>, GetRecipientsUseCaseProtocol {
    
    var result: UseCaseResponse<GetRecipientsUseCaseOutput, StringErrorOutput> = .error(.init("error"))
    
    override func executeUseCase(requestValues: GetRecipientsUseCaseInput) throws -> UseCaseResponse<GetRecipientsUseCaseOutput, StringErrorOutput> {
        return result
    }
}

import Foundation
import PLCommons
import CoreFoundationLib
@testable import ZusSMETransfer

final class GetVatAccountUseCaseStub: UseCase<GetVATAccountUseCaseInput, GetVATAccountCaseOkOutput, StringErrorOutput>, GetVATAccountUseCaseProtocol {
    
    var result: UseCaseResponse<GetVATAccountCaseOkOutput, StringErrorOutput> = .error(.init("error"))
    
    override func executeUseCase(requestValues: GetVATAccountUseCaseInput) throws -> UseCaseResponse<GetVATAccountCaseOkOutput, StringErrorOutput> {
        return result
    }
}

import Foundation
import PLCommons
import CoreFoundationLib
import PLCommonOperatives
import CoreDomain
@testable import ZusSMETransfer

final class AuthorizeTransactionUseCaseMock: UseCase<AuthorizeTransactionUseCaseInput, AuthorizeTransactionUseCaseOutput, StringErrorOutput>, AuthorizeTransactionUseCaseProtocol {
        
    override func executeUseCase(requestValues: AuthorizeTransactionUseCaseInput) throws -> UseCaseResponse<AuthorizeTransactionUseCaseOutput, StringErrorOutput> {
        .ok(AuthorizeTransactionUseCaseOutput(pendingChallenge: ChallengeRepresentableMock(), authorizationId: 222))
    }
}

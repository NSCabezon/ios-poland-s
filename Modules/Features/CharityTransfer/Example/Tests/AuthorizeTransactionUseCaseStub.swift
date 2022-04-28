import Foundation
import PLCommons
import CoreFoundationLib
import PLCommonOperatives
import CoreDomain
@testable import CharityTransfer

final class AuthorizeTransactionUseCaseStub: UseCase<AuthorizeTransactionUseCaseInput, AuthorizeTransactionUseCaseOutput, StringErrorOutput>, AuthorizeTransactionUseCaseProtocol {
    private let authorizationId: Int
    
    init(authorizationId: Int = 222) {
        self.authorizationId = authorizationId
    }
    
    override func executeUseCase(requestValues: AuthorizeTransactionUseCaseInput) throws -> UseCaseResponse<AuthorizeTransactionUseCaseOutput, StringErrorOutput> {
        .ok(
            AuthorizeTransactionUseCaseOutput(
                pendingChallenge: ChallengeRepresentableStub(),
                authorizationId: authorizationId
            )
        )
    }
}

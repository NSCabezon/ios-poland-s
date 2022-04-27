import CoreDomain
import CoreFoundationLib
import SANPLLibrary
@testable import ZusSMETransfer

final class PLAuthorizationCoordinatorMock: ChallengesHandlerDelegate {
    func handle(_ challenge: ChallengeRepresentable, authorizationId: String, completion: @escaping (ChallengeResult) -> Void) {
        completion(.handled(ChallengeVerificationMock()))
    }
}

struct ChallengeVerificationMock: ChallengeVerificationRepresentable {}

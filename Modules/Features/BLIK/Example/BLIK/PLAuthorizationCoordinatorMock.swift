import CoreDomain
import CoreFoundationLib
import SANPLLibrary
import BLIK

final class PLAuthorizationCoordinatorMock: BlikChallengesHandlerDelegate {
    private let challengeVerification: ChallengeVerificationRepresentable
   
    init(challengeVerification: ChallengeVerificationRepresentable) {
        self.challengeVerification = challengeVerification
    }
    
    func handle(
        _ challenge: ChallengeRepresentable,
        authorizationId: String,
        progressTotalTime: Float?,
        completion: @escaping (ChallengeResult) -> Void,
        bottomSheetDismissedClosure: (() -> Void)?
    ) {
        completion(.handled(challengeVerification))
    }
}

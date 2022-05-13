import SANPLLibrary

struct SendMoneyChallengeStub: SendMoneyChallengeRepresentable {
    var challengeRepresentable: String? {
        challenge
    }
    private let challenge: String?
    
    init(challenge: String? = "97216838") {
        self.challenge = challenge
    }
}

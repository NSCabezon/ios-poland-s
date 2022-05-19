import CoreDomain

struct PendingChallengeStub: ChallengeRepresentable {
    var identifier: String {
        id
    }
    private let id: String
    
    init(id: String = "") {
        self.id = id
    }
}

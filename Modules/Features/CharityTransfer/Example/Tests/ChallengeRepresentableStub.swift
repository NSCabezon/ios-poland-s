import CoreDomain

struct ChallengeRepresentableStub: ChallengeRepresentable {
    private let id: String
    
    init(id: String = "222") {
        self.id = id
    }
    
    var identifier: String {
        id
    }
}

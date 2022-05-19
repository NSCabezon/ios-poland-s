import SANPLLibrary

struct AuthorizationIdStub: AuthorizationIdRepresentable {
    var authorizationId: Int? {
        id
    }
    private let id: Int?
    
    init(id: Int? = 587) {
        self.id = id
    }
}

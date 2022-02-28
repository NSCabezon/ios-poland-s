import CoreDomain
import CoreFoundationLib
import SANPLLibrary

struct PLAuthorizationProcessorManagerMock: PLAuthorizationProcessorManagerProtocol {
    func doAuthorizeOperation(authorizationId: String, scope: String) -> RedirectUriRepresentable {
        fatalError()
    }
    
    func getPendingChallenge() throws -> Result<ChallengeRepresentable, NetworkProviderError> {
        .success(PendingChallengeMock())
    }
    
    func doConfirmChallenge(_ parameters: ConfirmChallengeParameters, authorizationId: String) throws -> Result<Void, NetworkProviderError> {
        fatalError()
    }
    
    func getIsChallengeConfirmed(authorizationID: String) throws -> Result<Void, NetworkProviderError> {
        fatalError()
    }
}

struct PendingChallengeMock: ChallengeRepresentable {
    var identifier: String {
        ""
    }
}

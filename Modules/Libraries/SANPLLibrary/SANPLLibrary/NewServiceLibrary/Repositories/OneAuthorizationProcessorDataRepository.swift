import CoreDomain
import SANLegacyLibrary

struct OneAuthorizationProcessorDataRepository: PLOneAuthorizationProcessorRepository {
    
    let bsanAuthorizationProcessorManager: PLAuthorizationProcessorManagerProtocol
    
    func confirmPin(authorizationId: String, parameters: ConfirmChallengeParameters) throws -> Result<Void, Error> {
        let result = try self.bsanAuthorizationProcessorManager.doConfirmChallenge(parameters, authorizationId: authorizationId)
        switch result {
        case .success(_):
            return .success(())
        case .failure(let error):
            return .failure(error)
        }
    }
    
    func authorizeOperation(authorizationId: String, scope: String) throws -> Result<RedirectUriRepresentable, Error> {
        let result = self.bsanAuthorizationProcessorManager.doAuthorizeOperation(authorizationId: authorizationId, scope: scope)
        return .success(result)
    }
    
    func getChallenges(authorizationId: String) throws -> Result<[ChallengeRepresentable], Error> {
        let result = try self.bsanAuthorizationProcessorManager.getPendingChallenge()
        switch result {
        case .success(let response):
            return .success([response])
        case .failure(let error):
            return .failure(error)
        }
    }
    
    func confirmChallenges(authorizationId: String, verification: [ChallengeVerificationRepresentable]) throws -> Result<Void, Error> {
        let result = try self.bsanAuthorizationProcessorManager.getIsChallengeConfirmed(authorizationID: authorizationId)
        switch result {
        case .success():
            return .success(())
        case .failure(let error):
            return .failure(error)
        }
    }
}

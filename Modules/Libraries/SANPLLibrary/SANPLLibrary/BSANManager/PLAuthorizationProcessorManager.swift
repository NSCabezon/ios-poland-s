import CoreDomain

public protocol PLAuthorizationProcessorManagerProtocol {
    func doAuthorizeOperation(authorizationId: String, scope: String) -> RedirectUriRepresentable
    func getPendingChallenge() throws -> Result<ChallengeRepresentable, NetworkProviderError>
    func doConfirmChallenge(_ parameters: ConfirmChallengeParameters, authorizationId: String) throws -> Result<NetworkProviderResponseWithStatus, NetworkProviderError>
    func getIsChallengeConfirmed(authorizationID: String) throws -> Result<Void,NetworkProviderError>
}

final class PLAuthorizationProcessorManager {
    
    private let authorizationProcessorDataSource: AuthorizationProcessorDataSourceProtocol
    private let bsanDataProvider: BSANDataProvider
    
    public init(bsanDataProvider: BSANDataProvider, networkProvider: NetworkProvider) {
        self.authorizationProcessorDataSource = AuthorizationProcessorDataSource(networkProvider: networkProvider, dataProvider: bsanDataProvider)
        self.bsanDataProvider = bsanDataProvider
    }
}
    
extension PLAuthorizationProcessorManager: PLAuthorizationProcessorManagerProtocol {
    
    func doAuthorizeOperation(authorizationId: String, scope: String) -> RedirectUriRepresentable {
        let result = self.authorizationProcessorDataSource.doAuthorizeOperation(authorizationId: authorizationId, scope: scope)
        return result
    }
    
    func getPendingChallenge() throws -> Result<ChallengeRepresentable, NetworkProviderError> {
        let result = try self.authorizationProcessorDataSource.getPendingChallenge()
        switch result {
        case .success(let pendingChallengeDTO):
            return .success(pendingChallengeDTO)
        case .failure(let error):
            return .failure(error)
        }
    }
    
    func doConfirmChallenge(_ parameters: ConfirmChallengeParameters, authorizationId: String) throws -> Result<NetworkProviderResponseWithStatus, NetworkProviderError> {
        return try authorizationProcessorDataSource.doConfirmChallenge(parameters, authorizationId: authorizationId)
    }
    
    func getIsChallengeConfirmed(authorizationID: String) throws -> Result<Void, NetworkProviderError> {
        let result = try self.authorizationProcessorDataSource.getIsChallengeConfirmed(authorizationID: authorizationID)
        switch result {
        case .success(_):
            return .success(())
        case .failure(let error):
            return .failure(error)
        }
    }
}

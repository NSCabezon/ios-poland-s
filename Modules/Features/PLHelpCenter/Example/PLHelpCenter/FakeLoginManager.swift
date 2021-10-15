import Foundation
import SANPLLibrary

typealias HelpCenterClientProfileProvider = () -> HelpCenterClientProfile

final class FakePLLoginManager: PLLoginManagerProtocol {
 
    private let clientProfileProvider: HelpCenterClientProfileProvider
    
    init(clientProfileProvider: @escaping HelpCenterClientProfileProvider) {
        self.clientProfileProvider = clientProfileProvider
    }
    
    func setDemoModeIfNeeded(for user: String) -> Bool {
        fatalError()
    }
    
    func doLogin(_ parameters: LoginParameters) throws -> Result<LoginDTO, NetworkProviderError> {
        fatalError()
    }
    
    func getPubKey() throws -> Result<PubKeyDTO, NetworkProviderError> {
        fatalError()
    }
    
    func getPersistedPubKey() throws -> PubKeyDTO {
        fatalError()
    }
    
    func doAuthenticateInit(_ parameters: AuthenticateInitParameters) throws -> Result<NetworkProviderResponseWithStatus, NetworkProviderError> {
        fatalError()
    }
    
    func doAuthenticate(_ parameters: AuthenticateParameters) throws -> Result<AuthenticateDTO, NetworkProviderError> {
        fatalError()
    }
    
    func getAuthCredentials() throws -> SANPLLibrary.AuthCredentials {
        let accessTokenCredentials: AccessTokenCredentials?
        switch clientProfileProvider() {
        case .notLogged:
            accessTokenCredentials = nil
        case .individual:
            accessTokenCredentials = AccessTokenCredentials(type: "authenticate.type", accessToken: "someAccessTokenOfIndividualUser", expires: nil)
        case .company:
            // TODO: Include Company User data when it will be known [MOBILE-8591]
            accessTokenCredentials = AccessTokenCredentials(type: "authenticate.type", accessToken: "someAccessTokenOfCompanyUser", expires: nil)
        }
        return AuthCredentials.init(login: nil, userId: nil, userCif: nil, companyContext: nil, accessTokenCredentials: accessTokenCredentials, trustedDeviceTokenCredentials: nil)
    }
    
    func getAppInfo() -> AppInfo? {
        fatalError()
    }
    
    func setAppInfo(_ appInfo: AppInfo) {
        
    }
    
    func getPendingChallenge(_ parameters: PendingChallengeParameters) throws -> Result<PendingChallengeDTO, NetworkProviderError> {
        fatalError()
    }
}

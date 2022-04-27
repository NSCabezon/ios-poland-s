import SANPLLibrary
import CoreFoundationLib

final class PLLoginManagerMock: PLLoginManagerProtocol {
    private let dependenciesResolver: DependenciesResolver
    
    init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
    }
    
    func setDemoModeIfNeeded(for user: String) -> Bool {
        fatalError()
    }
    
    func isDemoUser(userId: String) -> Bool {
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
    
    func getAuthCredentials() throws -> AuthCredentials {
        AuthCredentials(login: nil,
                        userId: 46425222,
                        userCif: nil,
                        companyContext: nil,
                        accessTokenCredentials: nil,
                        trustedDeviceTokenCredentials: nil)
    }
    
    func getAppInfo() -> AppInfo? {
        fatalError()
    }
    
    func setAppInfo(_ appInfo: AppInfo) {
        fatalError()
    }
    
    func doLogout() throws -> Result<NetworkProviderResponseWithStatus, NetworkProviderError> {
        fatalError()
    }
    
    func getLoginInfo() throws -> Result<LoginInfoDTO, NetworkProviderError> {
        fatalError()
    }
}

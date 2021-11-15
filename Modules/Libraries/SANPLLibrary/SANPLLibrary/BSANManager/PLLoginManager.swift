//
//  PLLoginManager.swift
//  SANPLLibrary
//
//  Created by Ernesto Fernandez Calles on 10/5/21.
//

import Foundation

public protocol PLLoginManagerProtocol {
    func setDemoModeIfNeeded(for user: String) -> Bool
    func isDemoUser(userId: String) -> Bool
    func doLogin(_ parameters: LoginParameters) throws -> Result<LoginDTO, NetworkProviderError>
    func getPubKey() throws -> Result<PubKeyDTO, NetworkProviderError>
    func getPersistedPubKey() throws -> PubKeyDTO
    func doAuthenticateInit(_ parameters: AuthenticateInitParameters) throws -> Result<NetworkProviderResponseWithStatus, NetworkProviderError>
    func doAuthenticate(_ parameters: AuthenticateParameters) throws -> Result<AuthenticateDTO, NetworkProviderError>
    func getAuthCredentials() throws -> AuthCredentials
    func getAppInfo() -> AppInfo?
    func setAppInfo(_ appInfo: AppInfo)
}

public final class PLLoginManager {
    private let loginDataSource: LoginDataSourceProtocol
    private let bsanDataProvider: BSANDataProvider
    private let demoInterpreter: DemoUserProtocol
    
    public init(bsanDataProvider: BSANDataProvider, networkProvider: NetworkProvider, demoInterpreter: DemoUserProtocol) {
        self.loginDataSource = LoginDataSource(networkProvider: networkProvider, dataProvider: bsanDataProvider)
        self.bsanDataProvider = bsanDataProvider
        self.demoInterpreter = demoInterpreter
    }
}

extension PLLoginManager: PLLoginManagerProtocol {
    
    public func isDemoUser(userId: String) -> Bool {
        return self.demoInterpreter.isDemoUser(userName: userId)
    }
    
    public func setAppInfo(_ appInfo: AppInfo) {
        self.bsanDataProvider.storeAppInfo(appInfo)
    }
    
    public func getAppInfo() -> AppInfo? {
        return self.bsanDataProvider.getAppInfo()
    }

    public func doLogin(_ parameters: LoginParameters) throws -> Result<LoginDTO, NetworkProviderError> {
        let result = try loginDataSource.doLogin(parameters)
        self.processLoginResult(parameters.selectedId, result: result)
        return result
    }

    public func getPubKey() throws -> Result<PubKeyDTO, NetworkProviderError> {
        let result = try loginDataSource.getPubKey()
        if case .success(let pubKeyDTO) = result {
            self.bsanDataProvider.storePublicKey(pubKeyDTO)
        }
        return result
    }

    public func getPersistedPubKey() throws -> PubKeyDTO {
        return try bsanDataProvider.getPublicKey()
    }

    public func doAuthenticateInit(_ parameters: AuthenticateInitParameters) throws -> Result<NetworkProviderResponseWithStatus, NetworkProviderError> {
        let result = try loginDataSource.doAuthenticateInit(parameters)
        return result
    }

    public func doAuthenticate(_ parameters: AuthenticateParameters) throws -> Result<AuthenticateDTO, NetworkProviderError> {
        let result = try loginDataSource.doAuthenticate(parameters)
        self.processAuthenticateResult(result)
        return result
    }

    public func getAuthCredentials() throws -> AuthCredentials {
        return try self.bsanDataProvider.getAuthCredentials()
    }

    public func setDemoModeIfNeeded(for user: String) -> Bool {
        guard self.demoInterpreter.isDemoModeAvailable,
            self.demoInterpreter.isDemoUser(userName: user) else { return false }
        self.bsanDataProvider.setDemoMode(true, user)
        return true
    }
}

// MARK: - Private Methods

private extension PLLoginManager {

    private func removeDemoModeIfNeeded() {
        guard let _ = self.bsanDataProvider.getDemoMode() else { return }
        self.bsanDataProvider.setDemoMode(false, nil)
    }

    private func processLoginResult(_ login: String, result: Result<LoginDTO, NetworkProviderError>) {
        if case .success = result {
            self.bsanDataProvider.createSessionData(UserDTO(loginType: .U, login: login))
        }
    }

    private func processAuthenticateResult(_ result: Result<AuthenticateDTO, NetworkProviderError>) {
        if case .success(let authenticate) = result {
            guard let login = try? self.bsanDataProvider.getSessionData().loggedUserDTO.login else {
                return
            }
            let accessTokenCredentials = AccessTokenCredentials(type: authenticate.type, accessToken: authenticate.access_token, expires: authenticate.expires)
            let trustedDeviceTokenCredentials = TrustedDeviceTokenCredentials(trustedDeviceToken: authenticate.trusted_device_token, clientId: authenticate.client_id, expiresIn: authenticate.expires_in)
            let authCredentials = AuthCredentials(login: login, userId: authenticate.userId, userCif: authenticate.userCif, companyContext: authenticate.companyContext, accessTokenCredentials: accessTokenCredentials, trustedDeviceTokenCredentials: trustedDeviceTokenCredentials)
            self.bsanDataProvider.storeAuthCredentials(authCredentials)
        }
    }
}

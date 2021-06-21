//
//  PLLoginManager.swift
//  SANPLLibrary
//
//  Created by Ernesto Fernandez Calles on 10/5/21.
//

import Foundation

public protocol PLLoginManagerProtocol {
    func doLogin(_ parameters: LoginParameters) throws -> Result<LoginDTO, NetworkProviderError>
    func getPubKey() throws -> Result<PubKeyDTO, NetworkProviderError>
    func doAuthenticateInit(_ parameters: AuthenticateInitParameters) throws -> Result<NetworkProviderResponseWithStatus, NetworkProviderError>
    func doAuthenticate(_ parameters: AuthenticateParameters) throws -> Result<AuthenticateDTO, NetworkProviderError>
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
    public func doLogin(_ parameters: LoginParameters) throws -> Result<LoginDTO, NetworkProviderError> {
        self.setDemoModeIfNeeded(parameters.selectedId)
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

    public func doAuthenticateInit(_ parameters: AuthenticateInitParameters) throws -> Result<NetworkProviderResponseWithStatus, NetworkProviderError> {
        let result = try loginDataSource.doAuthenticateInit(parameters)
        return result
    }

    public func doAuthenticate(_ parameters: AuthenticateParameters) throws -> Result<AuthenticateDTO, NetworkProviderError> {
        let result = try loginDataSource.doAuthenticate(parameters)
        self.processAuthenticateResult(result)
        return result
    }
}

// MARK: - Private Methods

private extension PLLoginManager {
    private func setDemoModeIfNeeded(_ user: String) {
        guard self.demoInterpreter.isDemoModeAvailable,
            self.demoInterpreter.isDemoUser(userName: user) else { return }
        self.bsanDataProvider.setDemoMode(true, user)
    }

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
            let authCredentials = AuthCredentials(login: login, authenticate: authenticate)
            self.bsanDataProvider.storeAuthCredentials(authCredentials)
        }
    }
}

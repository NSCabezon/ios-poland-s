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
    func getPersistedPubKey() throws -> PubKeyDTO
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
        return result
    }

    public func getPubKey() throws -> Result<PubKeyDTO, NetworkProviderError> {
        let result = try loginDataSource.getPubKey()
        switch result {
        case .success(let pubKeyDTO):
            bsanDataProvider.storePublicKey(pubKeyDTO)
            return .success(pubKeyDTO)
        case .failure(let error):
            return .failure(error)
        }
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
        return result
    }
}

// MARK: - Private Methods

private extension PLLoginManager {
    func setDemoModeIfNeeded(_ user: String) {
        guard self.demoInterpreter.isDemoModeAvailable,
            self.demoInterpreter.isDemoUser(userName: user) else { return }
        self.bsanDataProvider.setDemoMode(true, user)
    }

    func removeDemoModeIfNeeded() {
        guard let _ = self.bsanDataProvider.getDemoMode() else { return }
        self.bsanDataProvider.setDemoMode(false, nil)
    }
}

//
//  PLLoginManager.swift
//  SANPLLibrary
//
//  Created by Ernesto Fernandez Calles on 10/5/21.
//

import Foundation

public protocol PLLoginManagerProtocol {
    func doLoginWithNick(_ parameters: LoginNickParameters) throws -> Result<LoginDTO, Error>
    func doAuthenticateInit(_ parameters: AuthenticateInitParameters) throws -> Result<NetworkProviderResponseWithStatus, NetworkProviderError>
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
    public func doLoginWithNick(_ parameters: LoginNickParameters) throws -> Result<LoginDTO, Error> {
        let result = try loginDataSource.doLoginWithNick(parameters)
        switch result {
        case .success(let data):
            return .success(data)
        case .failure(let error):
            return .failure(error)
        }
    }

    public func doAuthenticateInit(_ parameters: AuthenticateInitParameters) throws -> Result<NetworkProviderResponseWithStatus, NetworkProviderError> {
        let result = try loginDataSource.doAuthenticateInit(parameters)
        switch result {
        case .success(let data):
            return .success(data)
        case .failure(let error):
            return .failure(error)
        }
    }
}

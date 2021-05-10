//
//  LoginDataSource.swift
//  SANPLLibrary
//
//  Created by Ernesto Fernandez Calles on 10/5/21.
//

import Foundation

protocol LoginDataSourceProtocol {
    func doLoginWithNick(nick: String) throws -> Result<LoginDTO, Error>
}

class LoginDataSource: LoginDataSourceProtocol {
    
    private let networkProvider: NetworkProvider
    private let dataProvider: BSANDataProvider
    // TODO: Fill
    private let basePath = ""
    
    init(networkProvider: NetworkProvider, dataProvider: BSANDataProvider) {
        self.networkProvider = networkProvider
        self.dataProvider = dataProvider
    }
    
    func doLoginWithNick(nick: String) throws -> Result<LoginDTO, Error> {
        guard let baseUrl = self.getBaseUrl() else {
            return .failure(NetworkProviderError.other)
        }
        
        let path = self.basePath + self.idpChannelPath
        let serviceName =  LoginServiceType.token.rawValue
        let absoluteUrl = baseUrl + path + serviceName
        let result: Result<IDPTokenDTO, NetworkProviderError> = self.networkProvider.loginRequest(LoginRequest(serviceName: serviceName,
                                                               serviceUrl: absoluteUrl,
                                                               method: .post,
                                                               body: body, headers: self.headers,
                                                               contentType: .urlEncoded,
                                                               localServiceName: .loginIDP)
        )
        return result
    }
}

private extension LoginDataSource {
    func getBaseUrl() -> String? {
        return try? self.dataProvider.getEnvironment().urlBase
    }
}

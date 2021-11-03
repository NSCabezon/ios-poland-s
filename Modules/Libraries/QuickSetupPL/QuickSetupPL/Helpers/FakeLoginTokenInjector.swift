//
//  FakeLoginTokenInjector.swift
//  Santander
//
//  Created by 186493 on 09/07/2021.
//

import Foundation
import Commons
import Models
import SANPLLibrary
import SANLegacyLibrary

final class FakeLoginTokenInjector {
    
    static func injectToken(dependenciesEngine: DependenciesInjector & DependenciesResolver) {

        guard let dataProvider = dependenciesEngine.resolve(for: BSANDataProviderProtocol.self) as? SANPLLibrary.BSANDataProvider else { return }
        
        let sessionData = try? dataProvider.getSessionData()
        let userDTO = sessionData?.loggedUserDTO ?? UserDTO(loginType: .U, login: "CreditCardRepaymentMockUser")
        dataProvider.createSessionData(userDTO)
        
        let accessTokenCredentials = AccessTokenCredentials(
            type: "authenticate.type",
            accessToken: "",
            expires: nil
        )
        let authCredentials = SANPLLibrary.AuthCredentials(
            login: userDTO.login,
            userId: nil,
            userCif: nil,
            companyContext: nil,
            accessTokenCredentials: accessTokenCredentials,
            trustedDeviceTokenCredentials: nil
        )
        dataProvider.storeAuthCredentials(authCredentials)
    }
}

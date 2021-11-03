//
//  BSANEnvironments.swift
//  SANPLLibrary_Tests
//
//  Created by Marcos Álvarez Mesa on 18/5/21.
//

@testable import SANPLLibrary

public struct BSANEnvironments {

    private enum EnvironmentsConstants {

        enum PRE {
            static let name = "EXTERNAL_PRE"
            static let endpoint = "https://micrositeoneapp2.santanderbankpolska.pl/centrum24-rest"
            static let restOauthClientId = ""
            static let blikAuthBaseUrl = "https://pluton2.centrum24.pl/centrum24-rest"
        }

        enum PRO {
            static let name = "PRO"
            static let endpoint = ""
            static let restOauthClientId = ""
            static let blikAuthBaseUrl = "https://pluton2.centrum24.pl/centrum24-rest"
        }
    }

    public static let environmentPro =
        BSANPLEnvironmentDTO(name: EnvironmentsConstants.PRO.name,
                             blikAuthBaseUrl: EnvironmentsConstants.PRO.blikAuthBaseUrl,
                             urlBase: EnvironmentsConstants.PRO.endpoint,
                             clientId: EnvironmentsConstants.PRO.restOauthClientId)

    public static let environmentPre =
        BSANPLEnvironmentDTO(name: EnvironmentsConstants.PRE.name,
                             blikAuthBaseUrl: EnvironmentsConstants.PRE.blikAuthBaseUrl,
                             urlBase: EnvironmentsConstants.PRE.endpoint,
                             clientId: EnvironmentsConstants.PRE.restOauthClientId)
}

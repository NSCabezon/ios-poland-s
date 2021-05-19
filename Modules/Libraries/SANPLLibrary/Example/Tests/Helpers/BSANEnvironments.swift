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
        }

        enum PRO {
            static let name = "PRO"
            static let endpoint = ""
            static let restOauthClientId = ""
        }
    }

    public static let environmentPro =
        BSANPLEnvironmentDTO(name: EnvironmentsConstants.PRO.name,
                             urlBase: EnvironmentsConstants.PRO.endpoint,
                             clientId: EnvironmentsConstants.PRO.restOauthClientId)

    public static let environmentPre =
        BSANPLEnvironmentDTO(name: EnvironmentsConstants.PRE.name,
                             urlBase: EnvironmentsConstants.PRE.endpoint,
                             clientId: EnvironmentsConstants.PRE.restOauthClientId)
}

import SANPLLibrary

public struct BSANEnvironments {

    private enum EnvironmentsConstants {

        enum PRE {
            static let name = "EXTERNAL_PRE"
            static let endpoint = ""
            static let restOauthClientId = ""
            static let urlNewRegistration = ""
        }

        enum PRO {
            static let name = "PRO"
            static let endpoint = ""
            static let restOauthClientId = ""
            static let urlNewRegistration = ""
        }
    }
    
    public static let environmentPro =
        BSANPLEnvironmentDTO(isHttps: false,
                             name: EnvironmentsConstants.PRO.name,
                             urlBase: EnvironmentsConstants.PRO.endpoint,
                             clientId: EnvironmentsConstants.PRO.restOauthClientId,
                             urlNewRegistration: EnvironmentsConstants.PRO.urlNewRegistration)
    
    public static let environmentPre =
        BSANPLEnvironmentDTO(isHttps: false,
                             name: EnvironmentsConstants.PRE.name,
                             urlBase: EnvironmentsConstants.PRE.endpoint,
                             clientId: EnvironmentsConstants.PRE.restOauthClientId,
                             urlNewRegistration: EnvironmentsConstants.PRE.urlNewRegistration)
}

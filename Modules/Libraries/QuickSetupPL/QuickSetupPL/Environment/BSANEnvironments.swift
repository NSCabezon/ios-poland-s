import SANPLLibrary

public struct BSANEnvironments {

    private enum EnvironmentsConstants {

        enum PRE {
            static let name = "EXTERNAL_PRE"
            static let endpoint = "https://micrositeoneapp2.santanderbankpolska.pl/omni/oneapp"
            static let blikAuthBaseUrl = "https://pluton2.centrum24.pl/centrum24-rest"
            static let restOauthClientId = ""
        }

        enum PRO {
            static let name = "PRO"
            static let endpoint = ""
            static let blikAuthBaseUrl = "https://pluton2.centrum24.pl/centrum24-rest"
            static let restOauthClientId = ""
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

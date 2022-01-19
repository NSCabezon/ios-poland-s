import SANPLLibrary

public struct BSANEnvironments {

    private enum EnvironmentsConstants {
        
        enum PRO {
            static let name = "PRO"
            static let endpoint = "https://www.centrum24.pl/omni/oneapp"
            static let blikAuthBaseUrl = "https://www.centrum24.pl/centrum24-rest"
            static let restOauthClientId = ""
        }

        enum PRE {
            static let name = "EXTERNAL_PRE"
            static let endpoint = "https://micrositeoneapp2.santanderbankpolska.pl/omni/oneapp"
            static let blikAuthBaseUrl = "https://pluton2.centrum24.pl/centrum24-rest"
            static let restOauthClientId = ""
        }
        
        enum PREPROD {
            static let name = "PREPROD"
            static let endpoint = "https://pluton1.centrum24.pl/omni/oneapp"
            static let blikAuthBaseUrl = "https://pluton1.centrum24.pl/centrum24-rest"
            static let restOauthClientId = ""
        }
        
        enum REGRESSION {
            static let name = "REGRESSION"
            static let endpoint = "https://pluton4.centrum24.pl/omni/oneapp"
            static let blikAuthBaseUrl = "https://pluton4.centrum24.pl/centrum24-rest"
            static let restOauthClientId = ""
        }
        
        enum UAT {
            static let name = "UAT"
            static let endpoint = "https://pluton2.centrum24.pl/omni/oneapp"
            static let blikAuthBaseUrl = "https://pluton2.centrum24.pl/centrum24-rest"
            static let restOauthClientId = ""
        }
        
        enum DEV {
            static let name = "DEV"
            static let endpoint = "https://micrositeoneapp2.santanderbankpolska.pl/oneapp/"
            static let blikAuthBaseUrl = "https://micrositeoneapp2.santanderbankpolska.pl/centrum24-rest"
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
    
    public static let environmentPreprod =
        BSANPLEnvironmentDTO(name: EnvironmentsConstants.PREPROD.name,
                             blikAuthBaseUrl: EnvironmentsConstants.PREPROD.blikAuthBaseUrl,
                             urlBase: EnvironmentsConstants.PREPROD.endpoint,
                             clientId: EnvironmentsConstants.PREPROD.restOauthClientId)
    
    public static let environmentRegression =
        BSANPLEnvironmentDTO(name: EnvironmentsConstants.REGRESSION.name,
                             blikAuthBaseUrl: EnvironmentsConstants.REGRESSION.blikAuthBaseUrl,
                             urlBase: EnvironmentsConstants.REGRESSION.endpoint,
                             clientId: EnvironmentsConstants.REGRESSION.restOauthClientId)
    
    public static let environmentUat =
        BSANPLEnvironmentDTO(name: EnvironmentsConstants.UAT.name,
                             blikAuthBaseUrl: EnvironmentsConstants.UAT.blikAuthBaseUrl,
                             urlBase: EnvironmentsConstants.UAT.endpoint,
                             clientId: EnvironmentsConstants.UAT.restOauthClientId)
    
    public static let environmentDev =
        BSANPLEnvironmentDTO(name: EnvironmentsConstants.DEV.name,
                             blikAuthBaseUrl: EnvironmentsConstants.DEV.blikAuthBaseUrl,
                             urlBase: EnvironmentsConstants.DEV.endpoint,
                             clientId: EnvironmentsConstants.DEV.restOauthClientId)
}

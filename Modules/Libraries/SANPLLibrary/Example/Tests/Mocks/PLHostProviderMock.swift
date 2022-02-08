import CoreFoundationLib
import SANLegacyLibrary
import SANLegacyLibrary
@testable import SANPLLibrary

class PLHostProviderMock: PLHostProviderProtocol {
    var environmentDefault: BSANPLEnvironmentDTO {
        getEnvironments().first!
    }
    
    func getEnvironments() -> [BSANPLEnvironmentDTO] {
        return [BSANPLEnvironmentDTO(
                 name: "",
                 blikAuthBaseUrl: "",
                 urlBase: "",
                 clientId: ""
             )
        ]
    }
}

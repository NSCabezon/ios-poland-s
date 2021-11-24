import DataRepository
import Repository
import SANLegacyLibrary
import Commons
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

import Foundation
import SANPLLibrary

final class PLHostProvider {
    let environmentDefault: BSANPLEnvironmentDTO
    
    init() {
        #if PRO
        self.environmentDefault = BSANEnvironments.environmentPro
        #elseif PRE
        self.environmentDefault = BSANEnvironments.environmentPre
        #elseif PREPROD
        self.environmentDefault = BSANEnvironments.environmentPreprod
        #elseif REG
        self.environmentDefault = BSANEnvironments.environmentRegression
        #elseif UAT
        self.environmentDefault = BSANEnvironments.environmentUat
        #else
        self.environmentDefault = BSANEnvironments.environmentPre
        #endif
    }
}

// MARK: - Private Methods
extension PLHostProvider: PLHostProviderProtocol {
    func getEnvironments() -> [BSANPLEnvironmentDTO] {
        return [BSANEnvironments.environmentPro,
                BSANEnvironments.environmentPre,
                BSANEnvironments.environmentPreprod,
                BSANEnvironments.environmentRegression,
                BSANEnvironments.environmentUat,
                BSANEnvironments.environmentDev]
    }
}

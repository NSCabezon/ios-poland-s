import Foundation
import SANPLLibrary

final class PLHostProvider {
    let environmentDefault: BSANPLEnvironmentDTO
    
    init() {
        self.environmentDefault = BSANEnvironments.environmentPre
    }
}

// MARK: - Private Methods

extension PLHostProvider: PLHostProviderProtocol {
    func getEnvironments() -> [BSANPLEnvironmentDTO] {
        return [BSANEnvironments.environmentPre,
                BSANEnvironments.environmentPro]
    }
}

import CoreFoundationLib
import SANPLLibrary

extension ModuleDependencies {
    func resolve() -> AppConfigRepositoryProtocol {
        return oldResolver.resolve()
    }
    
    func resolve() -> SegmentedUserRepository {
        return oldResolver.resolve()
    }
    
    func resolve() -> PLManagersProviderProtocol {
        return oldResolver.resolve()
    }
}

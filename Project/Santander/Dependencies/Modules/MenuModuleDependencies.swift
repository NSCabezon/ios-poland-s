import Foundation
import Menu
import Commons
import CoreFoundationLib
import RetailLegacy
import UI

extension ModuleDependencies {
    func retailLegacyPublicMenuCoordinator() -> RetailLegacyPublicMenuCoordinator {
        return RetailLegacyPublicMenuCoordinator(dependencies: self, keepingNavigation: false)
    }
    
    func resolve() -> PublicMenuToggleOutsider {
        self.drawer
    }
    
    func resolve() -> HomeTipsRepository {
        return PLHomeTipsRepository(dependenciesResolver: legacyDependenciesResolver)
    }
    
    func resolve() -> PublicMenuRepository {
        return PLPublicMenuRepository()
    }
    
    func resolve() -> SegmentedUserRepository {
        return legacyDependenciesResolver.resolve(for: SegmentedUserRepository.self)
    }
    
    func resolveSide() -> UINavigationController {
        drawer.currentSideMenuViewController as? UINavigationController ?? UINavigationController()
    }
    
    func publicMenuATMLocatorCoordinator() -> Coordinator {
        self.retailLegacyPublicMenuCoordinator()
    }
    
    func resolve() -> DataBinding {
        fatalError()
    }
}

extension BaseMenuViewController: PublicMenuToggleOutsider { }

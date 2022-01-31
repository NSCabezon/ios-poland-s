import Foundation
import Menu
import Commons
import CoreFoundationLib
import RetailLegacy
import UI
import SANPLLibrary

extension ModuleDependencies: PublicMenuExternalDependenciesResolver,
                                PublicMenuCustomActionExternalDependenciesResolver {
    
    func resolve() -> PublicMenuToggleOutsider {
        self.drawer
    }
    
    func resolve() -> HomeTipsRepository {
        return PLHomeTipsRepository(dependenciesResolver: legacyDependenciesResolver)
    }
    
    func resolve() -> PublicMenuRepository {
        return PLPublicMenuRepository(legacyDependenciesResolver.resolve(for: PLManagersProviderProtocol.self))
    }
    
    func resolveSideMenuNavigationController() -> UINavigationController {
        drawer.currentSideMenuViewController as? UINavigationController ?? UINavigationController()
    }
    
    func publicMenuATMLocatorCoordinator() -> Coordinator {
        return ToastCoordinator("generic_alert_notAvailableOperation")
    }
    
    func publicMenuCustomCoordinatorForAction() -> BindableCoordinator {
        return DefaultPublicMenuCustomActionCoordinator(dependencies: self, navigationController: resolveSideMenuNavigationController())
    }
}

extension BaseMenuViewController: PublicMenuToggleOutsider { }

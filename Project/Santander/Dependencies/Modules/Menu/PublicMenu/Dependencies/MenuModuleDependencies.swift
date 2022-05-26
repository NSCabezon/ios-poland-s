import Foundation
import Menu
import CoreFoundationLib
import RetailLegacy
import UI
import SANPLLibrary
import Cards

extension ModuleDependencies: PublicMenuExternalDependenciesResolver {
    
    func resolve() -> PublicMenuToggleOutsider {
        self.drawer
    }
    
    func resolve() -> HomeTipsRepository {
        return PLHomeTipsRepository(dependenciesResolver: oldResolver)
    }
    
    func resolve() -> PublicMenuRepository {
        return PLPublicMenuRepository(oldResolver.resolve(for: PLManagersProviderProtocol.self))
    }
    
    func resolveSideMenuNavigationController() -> UINavigationController {
        drawer.currentSideMenuViewController as? UINavigationController ?? UINavigationController()
    }
    
    func publicMenuATMLocatorCoordinator() -> Coordinator {
        return ToastCoordinator("generic_alert_notAvailableOperation")
    }
    
    func publicMenuCustomCoordinatorForAction() -> BindableCoordinator {
        return DefaultPublicMenuCustomActionCoordinator(dependenciesResolver: oldResolver, navigationController: resolveSideMenuNavigationController(), cardExternalDependencies: cardExternalDependenciesResolver())
    }
}

extension BaseMenuViewController: PublicMenuToggleOutsider { }

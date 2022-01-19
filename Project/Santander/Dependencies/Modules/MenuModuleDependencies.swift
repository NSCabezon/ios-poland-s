import Foundation
import Menu
import Commons
import CoreFoundationLib
import RetailLegacy
import UI
import SANPLLibrary

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
        return PLPublicMenuRepository(legacyDependenciesResolver.resolve(for: PLManagersProviderProtocol.self))
    }
    
    func resolve() -> SegmentedUserRepository {
        return legacyDependenciesResolver.resolve(for: SegmentedUserRepository.self)
    }
    
    func resolveSide() -> UINavigationController {
        drawer.currentSideMenuViewController as? UINavigationController ?? UINavigationController()
    }
    
    func publicMenuATMLocatorCoordinator() -> Coordinator {
        drawer.toggleSideMenu()
        return ToastCoordinator("generic_alert_notAvailableOperation")
    }
    
    func resolve() -> DataBinding {
        fatalError()
    }
    
    func publicMenuCustomCoordinatorForAction(_ action: String) -> Coordinator? {
        drawer.toggleSideMenu()
        guard let plAction = PLCustomActions(rawValue: action) else { return nil }
        switch plAction {
        case .otherUser:
            return ToastCoordinator("generic_alert_notAvailableOperation")
        case .information:
            return ToastCoordinator("generic_alert_notAvailableOperation")
        case .service:
            return ToastCoordinator("generic_alert_notAvailableOperation")
        case .offer:
            return ToastCoordinator("generic_alert_notAvailableOperation")
        case .mobileAuthorization:
            return ToastCoordinator("generic_alert_notAvailableOperation")
        }
    }
}

extension BaseMenuViewController: PublicMenuToggleOutsider { }

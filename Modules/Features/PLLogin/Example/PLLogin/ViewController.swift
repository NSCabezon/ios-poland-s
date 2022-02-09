import UIKit
//import QuickSetup
import PLLogin
import CoreFoundationLib
//import SANLibraryV3
import CoreFoundationLib
import PLCommons


class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.presentModule()
    }
    
    private func presentModule() {
        //QuickSetup.shared.doLogin(withUser: .demo)
        let navigationController = UINavigationController()
        navigationController.modalPresentationStyle = .fullScreen
        let coordinator = PLLoginModuleCoordinator(dependenciesResolver: dependenciesResolver, navigationController: navigationController)
        coordinator.start(.unrememberedLogin)
        self.present(navigationController, animated: true, completion: nil)
    }
    
    private lazy var dependenciesResolver: DependenciesResolver = {
        
        let defaultResolver = DependenciesDefault()
        
//        defaultResolver.register(for: PLLoginMainModuleCoordinatorDelegate.self) { _ in
//            return PLLoginMainModuleCoordinatorImp()
//        }
        
//        defaultResolver.register(for: BSANManagersProvider.self) { _ in
//            return QuickSetup.shared.managersProvider
//        }
        
        defaultResolver.register(for: UseCaseHandler.self) { _ in
            return UseCaseHandler(maxConcurrentOperationCount: 8, qualityOfService: .userInitiated)
        }
        
//        defaultResolver.register(for: GlobalPositionRepresentable.self) { _ in
//            return QuickSetup.shared.getGlobalPosition()!
//        }
        
        defaultResolver.register(for: GlobalPositionWithUserPrefsRepresentable.self) { resolver in
            let globalPosition = resolver.resolve(for: GlobalPositionRepresentable.self)
            let merger = GlobalPositionPrefsMergerEntity(resolver: resolver, globalPosition: globalPosition, saveUserPreferences: true)
            return merger
        }
        
        defaultResolver.register(for: TrackerManager.self) { _ in
            return TrackerManagerMock()
        }
        
//        defaultResolver.register(for: TimeManager.self) { _ in
//            return self.localeManager
//        }
//        
//        defaultResolver.register(for: StringLoader.self) { _ in
//            return self.localeManager
//        }

        defaultResolver.register(for: PLCompilationProtocol.self) { _ in
            return Compilation()
        }
        
        Localized.shared.setup(dependenciesResolver: defaultResolver)
        return defaultResolver
    }()
    
//    private lazy var localeManager: LocaleManager = {
//        let locale = LocaleManager()
//        locale.updateCurrentLanguage(language: .createFromType(languageType: .spanish, isPb: false))
//        return locale
//    }()
    
}

//final class PLLoginMainModuleCoordinatorImp: PLLoginMainModuleCoordinatorDelegate {
//
//}

class TrackerManagerMock: TrackerManager {
    
    func trackScreen(screenId: String, extraParameters: [String: String]) {
        
    }
    
    func trackEvent(screenId: String, eventId: String, extraParameters: [String: String]) {
        
    }
    
    func trackEmma(token: String) {
        
    }
}

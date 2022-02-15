import QuickSetup
import CoreFoundationLib
import Account
import UIKit
import QuickSetupPL

/// The ViewController that launches the Poland Example App.
/// In order to configure it, please see the code made for the Accounts module.
final class ViewController: UIViewController {
    
    /// Coordinator of the module to launch.
    /// The main coordinator of the module should be the one to conform to the
    /// DefaultModuleLauncher protocol
    /// ~~~
    /// var coordinator: DefaultModuleLauncher.Type {
    ///     return AccountsModuleCoordinator.self
    /// }
    /// ~~~
    var coordinator: DefaultModuleLauncher.Type {
        return AccountsModuleCoordinator.self
    }
    
    /// Entity that registers the necessary dependencies for the testing module.
    /// Create an entity in your module that conforms to the ModuleDependenciesInitializer protocol.
    /// ~~~
    /// var moduleDependencies: ModuleDependenciesInitializer.Type {
    ///     return AccountDependenciesInitializer.self
    /// }
    /// ~~~
    var moduleDependencies: ModuleDependenciesInitializer.Type {
        return AccountDependenciesInitializer.self
    }
    
    /// Services provider that the module will use to get services responses.
   
    private var serviceInjectors: [CustomServiceInjector] {
        return [PLServiceInjector()]
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.presentModule()
    }
    
    private func presentModule() {
        let navigationController = UINavigationController()
        navigationController.modalPresentationStyle = .fullScreen
        let coordinator = coordinator.init(dependenciesResolver: self.dependenciesResolver, navigationController: navigationController)
        coordinator.start()
        self.present(navigationController, animated: true, completion: nil)
    }
    
    private lazy var dependenciesResolver: DependenciesResolver = {
        let defaultResolver = DependenciesDefault()
        defaultResolver.register(for: [CustomServiceInjector].self) { _ in
            return self.serviceInjectors
        }
        let quickSetup: ServicesProvider = QuickSetupForPLLibrary(environment: BSANEnvironments.environmentPre, user: .demo, dependenciesEngine: defaultResolver)
        quickSetup.registerDependencies(in: defaultResolver)
        DefaultDependenciesInitializer(dependencies: defaultResolver).registerDefaultDependencies()
        moduleDependencies.init(dependencies: defaultResolver).registerDependencies()
        return defaultResolver
    }()
}

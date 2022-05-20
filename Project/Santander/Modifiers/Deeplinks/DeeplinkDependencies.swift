import UIKit
import CoreFoundationLib
import RetailLegacy

struct DeeplinkDependencies {
    private let drawer: BaseMenuViewController
    private let dependenciesEngine: DependenciesResolver & DependenciesInjector
    private let moduleDependencies: ModuleDependencies
    
    init(drawer: BaseMenuViewController, dependenciesEngine: DependenciesResolver & DependenciesInjector, moduleDependencies: ModuleDependencies) {
        self.drawer = drawer
        self.dependenciesEngine = dependenciesEngine
        self.moduleDependencies = moduleDependencies
    }
    
    func registerDependencies() {
        dependenciesEngine.register(for: CustomDeeplinkLauncher.self) { dependenciesResolver in
            return DeeplinkLauncher(dependenciesResolver: dependenciesResolver, dependencies: moduleDependencies)
        }
    }
}

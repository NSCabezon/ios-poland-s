import CoreTestData
import UI
@testable import PersonalArea

struct TestPersonalAreaConfigurationDependencies: PersonalAreaConfigurationDependenciesResolver {
    let injector: MockDataInjector
    var external: PersonalAreaConfigurationExternalDependenciesResolver
        
    init(injector: MockDataInjector, externalDependencies: TestPersonalAreaConfigurationExternalDependencies) {
        self.injector = injector
        self.external = externalDependencies
    }
    
    func resolve() -> PersonalAreaConfigurationCoordinator {
        fatalError()
    }
}

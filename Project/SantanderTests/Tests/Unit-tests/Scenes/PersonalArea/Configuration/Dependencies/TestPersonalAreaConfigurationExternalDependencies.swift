import PersonalArea
import CoreTestData
import CoreFoundationLib
import UI
import CoreDomain
@testable import Santander

struct TestPersonalAreaConfigurationExternalDependencies: PersonalAreaConfigurationExternalDependenciesResolver {
    let injector: MockDataInjector
    let globalPositionRepository: MockGlobalPositionDataRepository
    let oldDependenciesResolver: DependenciesResolver
    
    init(injector: MockDataInjector, oldDependenciesResolver: DependenciesResolver) {
        self.injector = injector
        self.globalPositionRepository = MockGlobalPositionDataRepository(injector.mockDataProvider.gpData.getGlobalPositionMock)
        self.oldDependenciesResolver = oldDependenciesResolver
    }
    
    func resolve() -> DependenciesResolver {
        return oldDependenciesResolver
    }
    
    func personalAreaConfigurationCoordinator() -> Coordinator {
        return ToastCoordinator()
    }
    
    func personalAreaPGPersonalizationCoordinator() -> Coordinator {
        return ToastCoordinator()
    }
    
    func resolve() -> LocalAppConfig {
        return LocalAppConfigMock()
    }
    
    func resolve() -> AppRepositoryProtocol {
        return AppRepositoryMock()
    }
    
    func resolve() -> AppConfigRepositoryProtocol {
        return MockAppConfigRepository(mockDataInjector: injector)
    }
    
    func resolve() -> GlobalPositionDataRepository {
        return globalPositionRepository
    }
    
    func resolve() -> PhotoThemeModifierProtocol? {
        return nil
    }
    
    func privateMenuCoordinator() -> Coordinator {
        return ToastCoordinator()
    }
    
    func resolve() -> TrackerManager {
        return TrackerManagerMock()
    }
    
    func personalAreaLanguageCoordinator() -> Coordinator {
        return ToastCoordinator()
    }
    
    func personalAreaPhotoThemeCoordinator() -> Coordinator {
        return ToastCoordinator()
    }
    
    func personalAreaAppInfoCoordinator() -> Coordinator {
        return ToastCoordinator()
    }
    
    func personalAreaAppPermissionsCoordinator() -> Coordinator {
        return ToastCoordinator()
    }
    
    func resolveOfferCoordinator() -> BindableCoordinator {
        return ToastCoordinator()
    }
    
    func resolve() -> GetPersonalAreaConfigurationPreferencesUseCase {
        fatalError()
    }
    
    func globalSearchCoordinator() -> Coordinator {
        return ToastCoordinator()
    }
    
    func resolve() -> PullOffersInterpreter {
        fatalError()
    }
    
    func resolve() -> NavigationBarItemBuilder {
        return NavigationBarItemBuilder(dependencies: self)
    }
    
    func resolve() -> UINavigationController {
        UINavigationController()
    }
    
    func resolve() -> PullOffersConfigRepositoryProtocol {
        return MockPullOffersConfigRepository(mockDataInjector: self.injector)
    }
    
    func resolve() -> CoreDependencies {
        fatalError()
    }
    
    func resolve() -> EngineInterface {
        fatalError()
    }
}

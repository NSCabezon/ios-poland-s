import XCTest
import CoreTestData
import CoreFoundationLib
import PersonalArea
@testable import Santander

class GetPLPersonalAreaConfigurationFieldsUseCaseTests: XCTestCase {
    lazy var externalDependencies = TestPersonalAreaConfigurationExternalDependencies(injector: self.mockDataInjector,oldDependenciesResolver: self.oldDependencies)
    lazy var dependencies: TestPersonalAreaConfigurationDependencies = {
        return TestPersonalAreaConfigurationDependencies(injector: self.mockDataInjector, externalDependencies: externalDependencies)
    }()
    
    lazy var oldDependencies: DependenciesResolver = {
        let dependencies = DependenciesDefault(father: nil)
        dependencies.register(for: UseCaseHandler.self) { _ in
            return UseCaseHandler()
        }
        dependencies.register(for: AppConfigRepositoryProtocol.self) { _ in
            return MockAppConfigRepository(mockDataInjector: self.mockDataInjector)
        }
        return dependencies
    }()
    
    lazy var mockDataInjector: MockDataInjector = {
        let injector = MockDataInjector()
        injector.register(
            for: \.gpData.getGlobalPositionMock,
            filename: "obtenerPosGlobal")
        injector.register(
            for: \.appConfigLocalData.getAppConfigLocalData,
            filename: "app_config_v2")
        return injector
    }()
    
    func test_given_PreferencesUseCase_when_CallUseCase_then_infoMatchedESConfig() throws {
        let sut = PLGetPersonalAreaConfigurationPreferencesUseCase(dependencies: self.externalDependencies)
        
        var preferences: PersonalAreaConfigurationPreferencesValuesRepresentable?
        _ = sut.fetchConfigurationPreferences().sink(receiveValue: { values in
            preferences = values
        })
        
        let currentLanguage = preferences?.currentLanguageName ?? ""
        let photoTheme = preferences?.photoThemeName ?? ""
        XCTAssertTrue(currentLanguage == "español")
        XCTAssertTrue(photoTheme == "onboarding_title_nature")
        XCTAssertTrue(preferences?.isEnabledLaguageSelection ?? false )
        XCTAssertTrue(preferences?.isAppInfoEnabled ?? false )
        XCTAssertTrue(preferences?.isEnabledNavigationPG ?? false )
        XCTAssertTrue(preferences?.isEnabledNavigationAlerts ?? false )
        XCTAssertTrue(preferences?.isEnabledNavigationPhotoTheme ?? false )
        XCTAssertFalse(preferences?.isEnabledConfigureAlertsInMenu ?? true )
    }
}

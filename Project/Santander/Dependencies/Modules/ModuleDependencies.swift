//
//  ModuleDependencies.swift
//  Santander
//
//  Created by Juan Carlos López Robles on 12/30/21.
//

import UI
import Loans
import Commons
import CoreDomain
import Foundation
import Onboarding
import OpenCombine
import RetailLegacy
import CoreFoundationLib

struct ModuleDependencies {
    let oldResolver: DependenciesInjector & DependenciesResolver
    let drawer: BaseMenuViewController
    let coreDependencies = DefaultCoreDependencies()
    
    init(oldResolver: DependenciesInjector & DependenciesResolver, drawer: BaseMenuViewController) {
        self.oldResolver = oldResolver
        self.drawer = drawer
        registerExternalDependencies()
    }
    
    func resolve() -> TimeManager {
        oldResolver.resolve()
    }

    func resolve() -> DependenciesResolver {
        return oldResolver
    }
    
    func resolve() -> AppConfigRepositoryProtocol {
        oldResolver.resolve()
    }
    
    func resolve() -> TrackerManager {
        oldResolver.resolve()
    }
    
    func resolve() -> BaseMenuViewController {
        return drawer
    }
    
    func resolve() -> UINavigationController {
        drawer.currentRootViewController as?
        UINavigationController ?? UINavigationController()
    }
}

// MARK: - Private
private extension ModuleDependencies {
    func registerExternalDependencies() {
        oldResolver.register(for: OnboardingExternalDependenciesResolver.self) { _ in
            return self
        }
    }
}

// MARK: - RetailLegacyExternalDependenciesResolver
extension ModuleDependencies: RetailLegacyExternalDependenciesResolver {}

// MARK: - CoreDependenciesResolver
extension ModuleDependencies: CoreDependenciesResolver {
    func resolve() -> CoreDependencies {
        return coreDependencies
    }
}

// MARK: - OnboardingExternalDependenciesResolver
extension ModuleDependencies: OnboardingExternalDependenciesResolver {
    func resolve() -> OnboardingPermissionOptionsProtocol? {
        return OnboardingPermissionOptions()
    }
    
    func resolve() -> BiometryRepository {
        fatalError()
    }
    
    func resolveOnBoardingCustomStepView(for identifier: String, coordinator: StepsCoordinator<OnboardingStep>) -> StepIdentifiable {
        fatalError()
    }
    
    func resolve() -> AppRepositoryProtocol {
        return oldResolver.resolve()
    }
    
    func resolve() -> CoreSessionManager {
        return oldResolver.resolve()
    }
    
    func resolve() -> LocalAppConfig {
        return oldResolver.resolve()
    }
    
    func resolve() -> PublicFilesManagerProtocol {
        return oldResolver.resolve()
    }
    
    func resolve() -> SessionDataManager {
        return oldResolver.resolve()
    }
    
    func resolve() -> StringLoader {
        return oldResolver.resolve()
    }
    
    func resolve() -> PhotoThemeModifierProtocol? {
        return nil
    }
    
    func resolve() -> BackgroundImageRepositoryProtocol {
        return BackgroundImageRepository(loadImageRepository: resolve(), manageImageRepositoryProtocol: resolve())
    }
    
    func resolve() -> DeleteBackgroundImageRepositoryProtocol {
        return DocumentsBackgroundImageRepository()
    }
    
    private func resolve() -> LoadBackgroundImageRepositoryProtocol {
        return FtpBackgroundImageRepository()
    }
    
    private func resolve() -> ManageBackgroundImageRepositoryProtocol {
        return DocumentsBackgroundImageRepository()
    }
    
    func resolve() -> LocationPermissionsManagerProtocol {
        return oldResolver.resolve()
    }
    
    func resolve() -> GlobalPositionWithUserPrefsRepresentable {
        return oldResolver.resolve()
    }
    
    func resolve() -> PushNotificationPermissionsManagerProtocol {
        return oldResolver.resolve()
    }
    
    func resolve() -> ApplePayEnrollmentManagerProtocol {
        return oldResolver.resolve()
    }
    
    func resolve() -> LocalAuthenticationPermissionsManagerProtocol {
        return oldResolver.resolve()
    }
    
    func resolve() -> OnboardingRepository {
        return DefaultOnboardingRepository()
    }
    
    func resolve() -> UserPreferencesRepository {
        return UserPreferencesRepositoryImpl(persistenceDataSource: oldResolver.resolve())
    }
    
    func resolve() -> MenuRepository {
        return DefaultMenuRepository()
    }
    
    func resolve() -> CompilationProtocol {
        return oldResolver.resolve()
    }
    
    func resolve() -> OnboardingConfiguration {
        return PLOnboardingConfiguration()
    }
}

struct PLOnboardingConfiguration: OnboardingConfiguration {
    var allowAbort: Bool {
        true
    }
    
    var numCountableSteps: Int {
        4
    }
     
    var steps: [StepsCoordinator<OnboardingStep>.Step] {
        []
    }
}

struct DefaultOnboardingRepository: OnboardingRepository {
    func getOnboardingInfo() -> AnyPublisher<OnboardingInfoRepresentable, Error> {
        return Just(OnboardingInfo(id: "12345678Z", name: "Pepe"))
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}

struct OnboardingInfo: OnboardingInfoRepresentable {
    let id: String
    let name: String
}

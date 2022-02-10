//
//  ModuleDependencies.swift
//  Santander
//
//  Created by Juan Carlos López Robles on 12/30/21.
//

import UI
import Loans
import CoreFoundationLib
import CoreDomain
import Foundation
import Onboarding
import RetailLegacy
import SANPLLibrary

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
        return oldResolver.resolve()
    }

    func resolve() -> DependenciesResolver {
        return oldResolver
    }
    
    func resolve() -> AppConfigRepositoryProtocol {
        return oldResolver.resolve()
    }
    
    func resolve() -> TrackerManager {
        return oldResolver.resolve()
    }
    
    func resolve() -> BaseMenuViewController {
        return drawer
    }
    
    func resolve() -> UINavigationController {
        return drawer.currentRootViewController as? UINavigationController ?? UINavigationController()
    }
    
    func loanHomeCoordinator() -> BindableCoordinator {
        return ToastCoordinator()
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
    func resolve() -> CoreFoundationLib.OnboardingPermissionOptionsProtocol? {
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
        let customerManager = oldResolver.resolve(for: PLManagersProviderProtocol.self).getCustomerManager()
        let globalPosition = oldResolver.resolve(for: GlobalPositionRepresentable.self)
        return OnboardingDataRepository(customerManager: customerManager, globalPosition: globalPosition)
    }
    
    func resolve() -> CompilationProtocol {
        return oldResolver.resolve()
    }
    
    func resolve() -> OnboardingConfiguration {
        return PLOnboardingConfiguration()
    }
}

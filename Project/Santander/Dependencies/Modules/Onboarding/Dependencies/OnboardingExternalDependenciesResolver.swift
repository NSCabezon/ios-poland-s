//
//  OnboardingExternalDependenciesResolver.swift
//  Santander
//
//  Created by Jose Ignacio de Juan Díaz on 18/3/22.
//

import Onboarding
import CoreFoundationLib
import UI
import CoreDomain

extension ModuleDependencies: OnboardingExternalDependenciesResolver {
    func resolve() -> CoreFoundationLib.OnboardingPermissionOptionsProtocol? {
        return OnboardingPermissionOptions()
    }
    
    func resolveOnBoardingCustomStepView(for identifier: String, coordinator: StepsCoordinator<OnboardingStep>) -> StepIdentifiable {
        fatalError()
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
        let oldResolver: DependenciesResolver = resolve()
        return oldResolver.resolve()
    }
    
    func resolve() -> CompilationProtocol {
        return oldResolver.resolve()
    }
    
    func resolve() -> OnboardingConfiguration {
        return PLOnboardingConfiguration()
    }
}

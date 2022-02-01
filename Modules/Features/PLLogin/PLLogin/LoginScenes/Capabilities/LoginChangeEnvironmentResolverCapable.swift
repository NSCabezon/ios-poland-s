//
//  LoginChangeEnvironmentResolverCapable.swift
//  PLLogin

import Foundation
import CoreFoundationLib

protocol LoginChangeEnvironmentResolverCapable {
    var dependenciesEngine: DependenciesResolver & DependenciesInjector { get }
}

extension LoginChangeEnvironmentResolverCapable {
    func registerEnvironmentDependencies() {
        
        self.dependenciesEngine.register(for: GetPLCurrentEnvironmentUseCase.self) { resolver in
            return GetPLCurrentEnvironmentUseCase(dependenciesResolver: resolver)
        }
    }
}

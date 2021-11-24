//
//  LoginChangeEnvironmentResolverCapable.swift
//  PLLogin

import Foundation
import Commons
import CommonUseCase

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

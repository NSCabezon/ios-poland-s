//
//  LoginChangeEnvironmentResolverCapable.swift
//  PLLogin

import Foundation
import Commons

protocol LoginChangeEnvironmentResolverCapable {
    var dependenciesEngine: DependenciesDefault { get }
}

extension LoginChangeEnvironmentResolverCapable {
    func registerEnvironmentDependencies() {
        self.dependenciesEngine.register(for: LoginEnvironmentLayer.self) { resolver in
            return LoginEnvironmentLayer(dependenciesResolver: resolver)
        }
        self.dependenciesEngine.register(for: GetPLCurrentEnvironmentUseCase.self) { resolver in
            return GetPLCurrentEnvironmentUseCase(dependenciesResolver: resolver)
        }
    }
}

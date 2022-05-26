//
//  ModuleDependencies+SavingsGlobalPositionDependenciesResolver.swift
//  Santander
//
//  Created by Jose Servet Font on 13/5/22.
//

import Foundation
import GlobalPosition
import CoreFoundationLib
import UI

protocol SavingsGlobalPositionDependenciesResolver {
    func resolve() -> GlobalPositionModuleCoordinatorDelegate
    func resolve() -> LocalAppConfig
    func resolve() -> DependenciesResolver
}

extension ModuleDependencies: SavingsGlobalPositionDependenciesResolver { }

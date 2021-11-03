//
//  AppSideMenuNavigationDependencies.swift
//  Santander
//
//  Created by 186493 on 24/08/2021.
//

import Foundation
import RetailLegacy
import Commons
import PLHelpCenter

final class AppSideMenuNavigationDependencies {
    private let drawer: BaseMenuViewController
    private let dependenciesEngine: DependenciesResolver & DependenciesInjector
    private let sideMenuCoordinatorNavigator: SideMenuCoordinatorNavigator

    init(drawer: BaseMenuViewController, dependenciesEngine: DependenciesResolver & DependenciesInjector) {
        self.drawer = drawer
        self.dependenciesEngine = dependenciesEngine
        self.sideMenuCoordinatorNavigator = SideMenuCoordinatorNavigator(drawer: drawer)
    }

    func registerDependencies() {
        dependenciesEngine.register(for: PLHelpCenterModuleCoordinatorDelegate.self) { [unowned self] _ in
            return self.sideMenuCoordinatorNavigator
        }
    }
}

private final class SideMenuCoordinatorNavigator {
    private let drawer: BaseMenuViewController
    
    init(drawer: BaseMenuViewController) {
        self.drawer = drawer
    }
}

extension SideMenuCoordinatorNavigator: PLHelpCenterModuleCoordinatorDelegate {
    func didSelectMenu() {
        drawer.toggleSideMenu()
    }
}

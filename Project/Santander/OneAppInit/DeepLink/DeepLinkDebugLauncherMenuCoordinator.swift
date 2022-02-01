//
//  DeepLinkDebugLauncherMenuCoordinator.swift
//  Santander
//
//  Created by 186493 on 01/10/2021.
//

import Foundation
import CoreFoundationLib
import UI
import CoreFoundationLib

protocol DeepLinkDebugLauncherMenuCoordinatorDelegate: AnyObject {
    func selectDeepLink(_ deepLink: DeepLinkEnumerationCapable)
}

final class DeepLinkDebugLauncherMenuCoordinator: ModuleCoordinator {
    
    var navigationController: UINavigationController?
    
    private let dependenciesEngine: DependenciesResolver & DependenciesInjector
    private lazy var deepLinkManager = dependenciesEngine.resolve(for: DeepLinkManagerProtocol.self)
    
    init(dependenciesEngine: DependenciesResolver & DependenciesInjector, navigationController: UINavigationController?) {
        self.dependenciesEngine = dependenciesEngine
        self.navigationController = navigationController
        self.setupDependencies()
    }
    
    func start() {
        let deepLinks: [PolandDeepLink] = PolandDeepLink.allCases
        let viewController = DeepLinkDebugLauncherMenuViewController(deepLinks: deepLinks, delegate: self)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}

private extension DeepLinkDebugLauncherMenuCoordinator {
    func setupDependencies() {
        self.dependenciesEngine.register(for: DeepLinkDebugLauncherMenuCoordinator.self) { _ in
            return self
        }
    }
}

extension DeepLinkDebugLauncherMenuCoordinator: DeepLinkDebugLauncherMenuCoordinatorDelegate {
    func selectDeepLink(_ deepLink: DeepLinkEnumerationCapable) {
        deepLinkManager.registerDeepLink(deepLink)
    }
}

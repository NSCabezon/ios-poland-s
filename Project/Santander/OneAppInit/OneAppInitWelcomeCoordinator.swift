//
//  OneAppInitWelcomeCoordinator.swift
//  Santander
//
//  Created by 186489 on 07/06/2021.
//

import Foundation
import CoreFoundationLib
import DemoAuthenticator
import UI

enum OneAppInitLoginType: String, CaseIterable {
    case skip = "Skip Login"
    case demo = "Demo Authenticator"
    case insertToken = "Insert Token"
}

protocol OneAppInitWelcomeCoordinatorProtocol: ModuleCoordinator {}

protocol OneAppInitWelcomeCoordinatorDelegate: AnyObject {
    func selectModule(_ module: OneAppInitModule)
}

final class OneAppInitWelcomeCoordinator: OneAppInitWelcomeCoordinatorProtocol {
    
    var navigationController: UINavigationController?
    private lazy var oneAppInitCoordinator = OneAppInitCoordinator(dependenciesEngine: dependenciesEngine, navigationController: navigationController)
    
    private let dependenciesEngine: DependenciesResolver & DependenciesInjector

    private lazy var mockInjector = CreditCardRepaymentMockInjector(dependenciesEngine: dependenciesEngine)
    
    init(dependenciesEngine: DependenciesResolver & DependenciesInjector, navigationController: UINavigationController?) {
        self.dependenciesEngine = dependenciesEngine
        self.navigationController = navigationController
        self.setupDependencies()
    }
    
    func start() {
        let welcomeVC = OneAppInitWelcomeViewController(loginTypes: OneAppInitLoginType.allCases, delegate: self)
        navigationController?.pushViewController(welcomeVC, animated: true)
    }
    
    func skipLogin() {
        oneAppInitCoordinator.start()
    }
}

private extension OneAppInitWelcomeCoordinator {
    func setupDependencies() {
        self.dependenciesEngine.register(for: OneAppInitWelcomeCoordinatorProtocol.self) { _ in
            return self
        }
    }
}

extension OneAppInitWelcomeCoordinator: AuthSuccessViewControllerProducing {
    func create(authToken: AuthToken) -> UIViewController {
        return oneAppInitCoordinator.create(with: authToken)
    }
}

extension OneAppInitWelcomeCoordinator: OneAppInitWelcomeDelegate {
    func selectLogin(_ type: OneAppInitLoginType) {
        switch type {
        case .demo:
            let loginFactory = LoginViewControllerFactory()
            let viewController = loginFactory.create(successViewControllerFactory: self)
            navigationController?.pushViewController(viewController, animated: true)
        case .skip:
            skipLogin()
        case .insertToken:
            FakeLoginTokenInjector.injectToken(dependenciesEngine: dependenciesEngine)
            skipLogin()
        }
    }
}

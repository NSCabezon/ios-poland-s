//
//  CustomPushNotificationCoordinator.swift
//  Santander
//
//  Created by 188418 on 28/12/2021.
//

import UIKit
import UI
import PLNotifications
import SANPLLibrary
import CoreFoundationLib
import PLLogin

public protocol CustomPushNotificationCoordinatorDelegate: AnyObject {
    func start(actionType: CustomPushLaunchAction)
}

protocol CustomPushNotificationCoordinatorProtocol {
    func pop()
}

public class CustomPushNotificationCoordinator: ModuleCoordinator {
    fileprivate var actionType: CustomPushLaunchAction?
    public weak var navigationController: UINavigationController?
    private let dependenciesEngine: DependenciesDefault
    
    public init(dependenciesResolver: DependenciesResolver, navigationController: UINavigationController?) {
        self.navigationController = navigationController
        self.dependenciesEngine = DependenciesDefault(father: dependenciesResolver)
        self.setupDependencies()
    }
    
    public func start() {
        let controller = self.dependenciesEngine.resolve(for: CustomPushNotificationViewController.self)
        self.navigationController?.pushViewController(controller, animated: true)
    }
}

extension CustomPushNotificationCoordinator: CustomPushNotificationCoordinatorProtocol {
    func pop() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func setupDependencies() {
        self.dependenciesEngine.register(for: CustomPushNotificationViewController.self) { resolver in
            var presenter = resolver.resolve(for: CustomPushNotificationPresenterProtocol.self)
            if let type = self.actionType {
                presenter.setType(type)
            }
            let viewController = CustomPushNotificationViewController(presenter: presenter)
            presenter.view = viewController
            return viewController
        }
        
        self.dependenciesEngine.register(for: CustomPushNotificationCoordinatorProtocol.self) { _ in
            return self
        }
        
        self.dependenciesEngine.register(for: CustomPushNotificationPresenterProtocol.self) { resolver in
            return CustomPushNotificationPresenter(dependenciesResolver: resolver)
        }
        
        self.dependenciesEngine.register(for: PLNotificationGetPushListUseCase.self) { resolver in
            return PLNotificationGetPushListUseCase(dependenciesResolver: resolver)
        }
        
        self.dependenciesEngine.register(for: PLNotificationGetPushDetailsUseCase.self) { resolver in
            return PLNotificationGetPushDetailsUseCase(dependenciesResolver: resolver)
        }
        
        self.dependenciesEngine.register(for: PLNotificationGetUnreadedPushCountUseCase.self) { resolver in
            return PLNotificationGetUnreadedPushCountUseCase(dependenciesResolver: resolver)
        }
        
        self.dependenciesEngine.register(for: PLNotificationGetEnabledPushCategoriesByDeviceUseCase.self) { resolver in
            return PLNotificationGetEnabledPushCategoriesByDeviceUseCase(dependenciesResolver: resolver)
        }
        
        self.dependenciesEngine.register(for: PLNotificationPostPushStatusUseCase.self) { resolver in
            return PLNotificationPostPushStatusUseCase(dependenciesResolver: resolver)
        }
        
        self.dependenciesEngine.register(for: PLNotificationPostPushStatusBeforeLoginUseCase.self) { resolver in
            return PLNotificationPostPushStatusBeforeLoginUseCase(dependenciesResolver: resolver)
        }
        
        self.dependenciesEngine.register(for: PLNotificationsUseCaseManagerProtocol.self) { _ in
            return PLNotificationsUseCaseManager(dependenciesEngine: self.dependenciesEngine)
        }
        
        self.dependenciesEngine.register(for: PLBeforeLoginUseCase.self) { resolver in
            return PLBeforeLoginUseCase(dependenciesResolver: resolver)
        }
        
        self.dependenciesEngine.register(for: PLNotificationGetPushDetailsBeforeLoginUseCase.self) { resolver in
            return PLNotificationGetPushDetailsBeforeLoginUseCase(dependenciesResolver: resolver)
        }
    }
    
    func showVC(_ viewController: UIViewController) {
        navigationController?.pushViewController(viewController, animated: true)
    }
}

extension CustomPushNotificationCoordinator: CustomPushNotificationCoordinatorDelegate {
    public func start(actionType: CustomPushLaunchAction) {
        self.actionType = actionType
        start()
    }
}

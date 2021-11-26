//
//  PhoneTopUpCoordinator.swift
//  PhoneTopUp
//
//  Created by 188216 on 19/11/2021.
//
import UI
import Commons
import PLCommons
import PLUI

public final class PhoneTopUpCoordinator: ModuleCoordinator {
    
    // MARK: Properties
    
    public var navigationController: UINavigationController?
    private let dependenciesEngine: DependenciesDefault
    
    // MARK: Lifecycle
    
    public init(dependenciesResolver: DependenciesResolver,
                navigationController: UINavigationController?) {
        self.navigationController = navigationController
        self.dependenciesEngine = DependenciesDefault(father: dependenciesResolver)
        self.setUpDependencies()
    }
    
    // MARK: Methods
    
    public func start() {
        let controller = self.dependenciesEngine.resolve(for: PhoneTopUpFormViewController.self)
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    private func setUpDependencies() {
        self.dependenciesEngine.register(for: PhoneTopUpFormViewController.self) { resolver in
            let viewController = PhoneTopUpFormViewController()
            return viewController
        }
    }
}

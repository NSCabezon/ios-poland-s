//
//  TopUpDataLoaderCoordinator.swift
//  PhoneTopUp
//
//  Created by 188216 on 01/02/2022.
//

import Commons
import PLCommonOperatives
import Foundation
import UI

public protocol TopUpDataLoaderCoordinatorProtocol: AnyObject, ModuleCoordinator {
    func showForm(with formData: TopUpPreloadedFormData)
    func close()
}

public final class TopUpDataLoaderCoordinator: TopUpDataLoaderCoordinatorProtocol {
    // MARK: Properties
    
    public weak var navigationController: UINavigationController?
    private let dependenciesEngine: DependenciesDefault
    private let settings: TopUpSettings
    
    // MARK: Lifecycle
    
    public init(dependenciesResolver: DependenciesResolver,
         navigationController: UINavigationController?,
         settings: TopUpSettings) {
        self.navigationController = navigationController
        self.dependenciesEngine = DependenciesDefault(father: dependenciesResolver)
        self.settings = settings
        self.setupDependencies()
    }
    
    // MARK: SetUp
    
    private func setupDependencies() {
        self.dependenciesEngine.register(for: AccountForDebitMapping.self) { _ in
            return AccountForDebitMapper()
        }
        
        self.dependenciesEngine.register(for: OperatorMapping.self) { _ in
            return OperatorMapper()
        }
        
        self.dependenciesEngine.register(for: GSMOperatorMapping.self) { _ in
            return GSMOperatorMapper()
        }
        
        self.dependenciesEngine.register(for: MobileContactMapping.self) { _ in
            return MobileContactMapper()
        }
        
        self.dependenciesEngine.register(for: TopUpDataLoaderCoordinatorProtocol.self) { _ in
            return self
        }
         
        self.dependenciesEngine.register(for: TopUpDataLoaderPresenterProtocol.self) { [settings] resolver in
            return TopUpDataLoaderPresenter(dependenciesResolver: resolver, settings: settings)
        }

        self.dependenciesEngine.register(for: TopUpDataLoaderViewController.self) { resolver in
            let presenter = resolver.resolve(for: TopUpDataLoaderPresenterProtocol.self)
            let viewController = TopUpDataLoaderViewController(
                presenter: presenter)
            presenter.view = viewController
            return viewController
        }
    }
    
    // MARK: Methods
    
    public func start() {
        let controller = self.dependenciesEngine.resolve(for: TopUpDataLoaderViewController.self)
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    public func close() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    public func showForm(with formData: TopUpPreloadedFormData) {
        let formCoordinator = PhoneTopUpFormCoordinator(dependenciesResolver: dependenciesEngine,
                                                        navigationController: navigationController,
                                                        formData: formData)
        formCoordinator.start()
    }
}


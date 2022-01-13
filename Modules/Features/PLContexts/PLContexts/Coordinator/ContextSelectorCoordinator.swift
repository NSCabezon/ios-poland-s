//
//  ContextSelectorCoordinator.swift
//  PLUI
//
//  Created by Ernesto Fernandez Calles on 22/12/21.
//

import Foundation
import Commons
import UI
import CommonUseCase
import CoreDomain
import SANPLLibrary

public final class ContextSelectorCoordinator: ModuleCoordinator {
    public weak var navigationController: UINavigationController?
    weak var rootViewController: ContextSelectorViewController?
    let dependenciesEngine: DependenciesResolver & DependenciesInjector
    let bsanDataProvider: BSANDataProvider
    
    public init(resolver: DependenciesResolver, bsanDataProvider: BSANDataProvider, coordinatingViewController controller: UINavigationController?) {
        
        self.dependenciesEngine = DependenciesDefault(father: resolver)
        self.bsanDataProvider = bsanDataProvider
        self.navigationController = controller
        
        self.dependenciesEngine.register(for: ContextSelectorPresenterProtocol.self) { dependenciesResolver in
            return ContextSelectorPresenter(dependenciesResolver: dependenciesResolver, bsanDataProvider: self.bsanDataProvider)
        }
        
        self.dependenciesEngine.register(for: ContextSelectorViewController.self) { [unowned self] dependenciesResolver in
            let presenter: ContextSelectorPresenterProtocol = dependenciesResolver.resolve(for: ContextSelectorPresenterProtocol.self)
            let viewController = ContextSelectorViewController(nibName: "ContextSelectorViewController",
                                                               bundle: .module,
                                                               presenter: presenter)
            self.rootViewController = viewController
            presenter.view = viewController
            return viewController
        }
        
        self.dependenciesEngine.register(for: ContextSelectorCoordinator.self) { _ in
            return self
        }
    }
    
    public func start() {
        self.navigationController?.present(dependenciesEngine.resolve(for: ContextSelectorViewController.self), animated: true, completion: nil)
    }
    
    func dismiss() {
        self.rootViewController?.dismiss(animated: true, completion: nil)
    }
}

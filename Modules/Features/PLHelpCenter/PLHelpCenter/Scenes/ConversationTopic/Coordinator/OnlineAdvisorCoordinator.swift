//
//  OnlineAdvisorCoordinator.swift
//  PLHelpCenter
//
//  Created by 185860 on 23/03/2022.
//

import Foundation
import CoreFoundationLib
import UI


public protocol OnlineAdvisorCoordinatorProtocol: ModuleCoordinator {
    var presenter: OnlineAdvisorCoordinatorPresenterProtocol? { get set }
}

public class OnlineAdvisorCoordinator: OnlineAdvisorCoordinatorProtocol {
    public var presenter: OnlineAdvisorCoordinatorPresenterProtocol?
    
    public var navigationController: UINavigationController?
    public let dependenciesEngine: DependenciesDefault
    
    public func start() {
        presenter?.getUserContext(parameters: presenter?.onlineAdvisorParameters)
    }
    
    public init(dependenciesResolver: DependenciesResolver, navigationController: UINavigationController? = nil) {
        self.navigationController = navigationController
        self.dependenciesEngine = DependenciesDefault(father: dependenciesResolver)
        self.setupDependencies()
        self.presenter = dependenciesEngine.resolve(for: OnlineAdvisorCoordinatorPresenterProtocol.self)
    }
}

private extension OnlineAdvisorCoordinator {
    func setupDependencies() {
        self.dependenciesEngine.register(for: OnlineAdvisorCoordinatorPresenterProtocol.self) { resolver in
            return OnlineAdvisorCoordinatorPresenter(dependenciesResolver: resolver)
        }

        self.dependenciesEngine.register(for: GetUserContextForOnlineAdvisorUseCaseProtocol.self) { resolver in
            return GetUserContextForOnlineAdvisorUseCase(dependenciesResolver: resolver)
        }
        
    }
    
}

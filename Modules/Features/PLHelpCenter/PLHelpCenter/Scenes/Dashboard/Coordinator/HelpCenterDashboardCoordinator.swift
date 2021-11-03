//
//  HelpCenterCoordinator.swift
//  Pods
//
//  Created by 186484 on 04/06/2021.
//  

import UI
import Models
import Commons

/**
    #Add method that must be handle by the PLHelpCenterCoordinator like
    navigation between the module scene and so on.
*/
protocol HelpCenterDashboardCoordinatorProtocol: ModuleCoordinator {
    var onCloseConfirmed: (() -> Void)? { get set }
    func goBack()
    func goToConversationTopicScene(advisorDetails: HelpCenterConfig.AdvisorDetails)
}

final class HelpCenterDashboardCoordinator: HelpCenterDashboardCoordinatorProtocol {
    weak var navigationController: UINavigationController?
    private let dependenciesEngine: DependenciesDefault
    var onCloseConfirmed: (() -> Void)?

    init(dependenciesResolver: DependenciesResolver, navigationController: UINavigationController?) {
        self.navigationController = navigationController
        self.dependenciesEngine = DependenciesDefault(father: dependenciesResolver)
        self.setupDependencies()
    }
    
    func start() {
        let controller = self.dependenciesEngine.resolve(for: HelpCenterDashboardViewController.self)
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func goBack() {
        navigationController?.popViewController(animated: true)
    }
    
    func goToConversationTopicScene(advisorDetails: HelpCenterConfig.AdvisorDetails) {
        let coord = HelpCenterConversationTopicCoordinator(dependenciesResolver: dependenciesEngine,
                                                           navigationController: navigationController)
        coord.start(with: advisorDetails)
    }
}

/**
 #Register Scene depencencies.
*/

private extension HelpCenterDashboardCoordinator {
    func setupDependencies() {
        self.dependenciesEngine.register(for: HelpCenterDashboardCoordinatorProtocol.self) { _ in
            return self
        }
         
        self.dependenciesEngine.register(for: HelpCenterDashboardPresenterProtocol.self) { resolver in
            return HelpCenterDashboardPresenter(dependenciesResolver: resolver)
        }
        
        self.dependenciesEngine.register(for: GetHelpCenterSceneTypeUseCaseProtocol.self) { resolver in
            return GetHelpCenterSceneTypeUseCase(dependenciesResolver: resolver)
        }
        
        self.dependenciesEngine.register(for: GetHelpCenterConfigUseCaseProtocol.self) { resolver in
            return GetHelpCenterConfigUseCase(dependenciesResolver: resolver)
        }
        
        self.dependenciesEngine.register(for: GetUserContextForOnlineAdvisorUseCaseProtocol.self) { resolver in
            return GetUserContextForOnlineAdvisorUseCase(dependenciesResolver: resolver)
        }
         
        self.dependenciesEngine.register(for: HelpCenterDashboardViewController.self) { resolver in
            var presenter = resolver.resolve(for: HelpCenterDashboardPresenterProtocol.self)
            let viewController = HelpCenterDashboardViewController(presenter: presenter)
            presenter.view = viewController
            return viewController
        }
    }
}

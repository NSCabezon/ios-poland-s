import UI
import CoreFoundationLib
import Commons

/**
    #Add method that must be handle by the PLHelpCenterCoordinator like
    navigation between the module scene and so on.
*/
protocol HelpCenterConversationTopicCoordinatorProtocol: ModuleCoordinator {
    var onCloseConfirmed: (() -> Void)? { get set }
    
    func start(with advisorDetails: HelpCenterConfig.AdvisorDetails)
    func goBack()
}

final class HelpCenterConversationTopicCoordinator: HelpCenterConversationTopicCoordinatorProtocol {
    weak var navigationController: UINavigationController?
    private let dependenciesEngine: DependenciesDefault
    var onCloseConfirmed: (() -> Void)?

    init(dependenciesResolver: DependenciesResolver, navigationController: UINavigationController?) {
        self.navigationController = navigationController
        self.dependenciesEngine = DependenciesDefault(father: dependenciesResolver)
        self.setupDependencies()
    }
    
    func start() {
        fatalError("Please use start with")
    }
    
    func start(with advisorDetails: HelpCenterConfig.AdvisorDetails) {
        var presenter = dependenciesEngine.resolve(for: HelpCenterConversationTopicPresenterProtocol.self)
        let viewController = HelpCenterConversationTopicViewController(presenter: presenter)
        presenter.view = viewController
        presenter.setUp(with: advisorDetails)
                
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func goBack() {
        navigationController?.popViewController(animated: true)
    }
}

/**
 #Register Scene depencencies.
*/

private extension HelpCenterConversationTopicCoordinator {
    func setupDependencies() {
        self.dependenciesEngine.register(for: HelpCenterConversationTopicCoordinatorProtocol.self) { _ in
            return self
        }
         
        self.dependenciesEngine.register(for: HelpCenterConversationTopicPresenterProtocol.self) { resolver in
            return HelpCenterConversationTopicPresenter(dependenciesResolver: resolver)
        }
        
        self.dependenciesEngine.register(for: GetHelpCenterConfigUseCaseProtocol.self) { resolver in
            return GetHelpCenterConfigUseCase(dependenciesResolver: resolver)
        }
    }
}


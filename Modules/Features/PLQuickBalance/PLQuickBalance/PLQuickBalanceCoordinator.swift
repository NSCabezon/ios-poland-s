import UI
import CoreFoundationLib
import SANPLLibrary

public protocol PLQuickBalanceCoordinatorProtocol: ModuleCoordinator {
    func pop()
    func showEnableQuickBalanceView()
    func showSelectAccountView(viewModel: PLQuickBalanceSettingsViewModel,
                               delegate: PLQuickBalanceSetAccountViewControllerDelegate,
                               accountType: PLQuickBalanceAccountType)
}

public class PLQuickBalanceCoordinator {
    public weak var navigationController: UINavigationController?
    private let dependenciesEngine: DependenciesDefault
    
    public init(dependenciesResolver: DependenciesResolver,
                navigationController: UINavigationController?) {
        self.navigationController = navigationController
        self.dependenciesEngine = DependenciesDefault(father: dependenciesResolver)
        self.setupDependencies()
    }
    
    public func start() {
        let loadingVC = dependenciesEngine.resolve(for: PLQuickBalanceViewController.self)
        loadingVC.modalPresentationStyle = .fullScreen
        navigationController?.isNavigationBarHidden = true
        navigationController?.pushViewController(loadingVC, animated: true)

    }
}

extension PLQuickBalanceCoordinator: PLQuickBalanceCoordinatorProtocol {
    public func pop() {
        navigationController?.popViewController(animated: true)
    }
    
    public func showEnableQuickBalanceView() {
        if dependenciesEngine.resolve(for: CoreSessionManager.self).isSessionActive {
            let settingsVC = dependenciesEngine.resolve(for: PLQuickBalanceSettingsVC.self)
            navigationController?.pushViewController(settingsVC, animated: true)
        } else {
            let deepLinkManager = dependenciesEngine.resolve(for: DeepLinkManagerProtocol.self)
            let quickBalanceDeeplink = DeepLink.custom(deeplink: "quickBalance", userInfo: [ :])
            deepLinkManager.registerDeepLink(quickBalanceDeeplink)
            pop()
        }
    }

    public func showSelectAccountView(viewModel: PLQuickBalanceSettingsViewModel,
                                      delegate: PLQuickBalanceSetAccountViewControllerDelegate,
                                      accountType: PLQuickBalanceAccountType) {
        let quickBalanceVC = PLQuickBalanceSetAccountViewController(viewModel: viewModel,
                                                                    delegate: delegate,
                                                                    accountType: accountType)
                navigationController?.pushViewController(quickBalanceVC, animated: true)
    }
}

extension PLQuickBalanceCoordinator {
    private func setupDependencies() {
        self.dependenciesEngine.register(for: PLQuickBalancePresenterProtocol.self) { resolver in
            return PLQuickBalancePresenter(dependenciesResolver: resolver)
        }
        
        self.dependenciesEngine.register(for: GetLastTransactionProtocol.self) { resolver in
            return GetLastTransactionUseCase(dependenciesResolver: resolver)
        }
        
        self.dependenciesEngine.register(for: PLQuickBalanceViewController.self) { resolver in
            let presenter = resolver.resolve(for: PLQuickBalancePresenterProtocol.self)
            let viewController = PLQuickBalanceViewController(presenter: presenter)
            presenter.view = viewController
            return viewController
        }

        self.dependenciesEngine.register(for: PLQuickBalanceSettingsPresenterProtocol.self) { resolver in
            return PLQuickBalanceSettingsPresenter(dependenciesResolver: resolver)
        }

        self.dependenciesEngine.register(for: PLQuickBalanceSettingsVC.self) { resolver in
            var presenter = resolver.resolve(for: PLQuickBalanceSettingsPresenterProtocol.self)
            let viewController = PLQuickBalanceSettingsVC(presenter: presenter, dependenciesResolver: resolver)
            presenter.view = viewController
            return viewController
        }

        self.dependenciesEngine.register(for: PLQuickBalancePostSettingsUseCaseProtocol.self) { resolver in
            return PLQuickBalancePostSettingsUseCase(dependenciesResolver: resolver)
        }

        self.dependenciesEngine.register(for: PLQuickBalanceGetSettingsUseCaseProtocol.self) { resolver in
            return PLQuickBalanceGetSettingsUseCase(dependenciesResolver: resolver)
        }
    }
}


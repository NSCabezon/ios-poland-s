import UI
import CoreFoundationLib
import Operative

public protocol CreditCardRepaymentModuleCoordinatorProtocol {
    var navigationController: UINavigationController? { get set }
    func start()
    func start(with creditCardEntity: CardEntity)
}

public final class CreditCardRepaymentModuleCoordinator: CreditCardRepaymentModuleCoordinatorProtocol {
    public weak var navigationController: UINavigationController?
    private let dependenciesEngine: DependenciesDefault
    private let formManager: CreditCardRepaymentFormManager
    
    public init(dependenciesResolver: DependenciesResolver, navigationController: UINavigationController?) {
        self.navigationController = navigationController
        self.dependenciesEngine = DependenciesDefault(father: dependenciesResolver)
        self.formManager = CreditCardRepaymentFormManager()
        setupDependencies()
    }
    
    public func start() {
        goToCreditCardRepayment(operativeData: CreditCardRepaymentOperativeData(formManager: formManager), handler: self)
    }
    
    public func start(with creditCardEntity: CardEntity) {
        goToCreditCardRepayment(
            operativeData: CreditCardRepaymentOperativeData(
                formManager: formManager,
                creditCardEntity: creditCardEntity
            ),
            handler: self
        )
    }
}

extension CreditCardRepaymentModuleCoordinator: CreditCardRepaymentLauncher {}

private extension CreditCardRepaymentModuleCoordinator {
    func setupDependencies() {
        let navigationController = navigationController
        
        self.dependenciesEngine.register(for: CreditCardRepaymentModuleCoordinator.self) { _ in
            return self
        }
        
        self.dependenciesEngine.register(for: CreateCreditCardRepaymentFormUseCaseProtocol.self) { dependenciesResolver in
            return CreateCreditCardRepaymentFormUseCase(dependenciesResolver: dependenciesResolver)
        }
        
        self.dependenciesEngine.register(for: CreditCardRepaymentFormManager.self) { [unowned self] dependenciesResolver in
            return self.formManager
        }
        
        self.dependenciesEngine.register(for: AccountChooseListCoordinatorProtocol.self) { resolver in
            AccountChooseListCoordinator(
                dependenciesResolver: resolver,
                navigationController: navigationController
            )
        }
        
        self.dependenciesEngine.register(for: RepaymentAmountOptionChooseListCoordinatorProtocol.self) { resolver in
            RepaymentAmountOptionChooseListCoordinator(
                dependenciesResolver: resolver,
                navigationController: navigationController
            )
        }
        
        self.dependenciesEngine.register(for: CreditCardRepaymentFinishingCoordinatorProtocol.self) { [unowned self] _ in
            CreditCardRepaymentFinishingCoordinator(dependenciesEngine: self.dependenciesEngine, navigatorController: navigationController)
        }
    }
}

extension CreditCardRepaymentModuleCoordinator: OperativeLauncherHandler {
    public var operativeNavigationController: UINavigationController? {
        return self.navigationController
    }
    
    public var dependenciesResolver: DependenciesResolver {
        return self.dependenciesEngine
    }
    
    public func showOperativeLoading(completion: @escaping () -> Void) {
        showLoading(completion: completion)
    }
    
    public func hideOperativeLoading(completion: @escaping () -> Void) {
        dismissLoading(completion: completion)
    }
    
    public func showOperativeAlertError(keyTitle: String?, keyDesc: String?, completion: (() -> Void)?) {
        if keyDesc == CreateCreditCardRepaymentFormError.noCards.rawValue {
            guard let navigationController = self.navigationController else { return }
            let errorDialog = CreditCardRepaymentDialogFactory.makeNoCardsErrorDialog()
            errorDialog.showIn(navigationController)
        } else {
            showGenericErrorDialog(withDependenciesResolver: dependenciesResolver)
        }
        completion?()
    }
}

extension CreditCardRepaymentModuleCoordinator: LoadingViewPresentationCapable {
    public var associatedLoadingView: UIViewController {
        self.navigationController?.topViewController ?? UIViewController()
    }
}

extension CreditCardRepaymentModuleCoordinator: GenericErrorDialogPresentationCapable {
    public var associatedGenericErrorDialogView: UIViewController {
        self.navigationController?.topViewController ?? UIViewController()
    }
}

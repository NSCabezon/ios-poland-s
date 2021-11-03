import Foundation
import Operative
import Models
import Commons
import DomainCommon
import UI

final class CreditCardRepaymentOperative: Operative {
    
    // TODO: Those Finish options are not confirmed
    enum FinishingOption {
        case globalPosition
        case makeAnotherPayment
    }
    
    var dependencies: DependenciesInjector & DependenciesResolver
    private var isSelectedAccountStepVisible: Bool = false
    var steps: [OperativeStep] = []
    weak var container: OperativeContainerProtocol?
    lazy var operativeData: CreditCardRepaymentOperativeData = {
        guard let container = self.container else { fatalError() }
        return container.get()
    }()
    
    lazy var finishingCoordinator: OperativeFinishingCoordinator = {
        self.dependencies.resolve(for: CreditCardRepaymentFinishingCoordinatorProtocol.self)
    }()
    
    private lazy var formManager = self.dependencies.resolve(for: CreditCardRepaymentFormManager.self)
 
    init(dependencies: DependenciesInjector & DependenciesResolver) {
        self.dependencies = dependencies
        setupDependencies()
    }
}

private extension CreditCardRepaymentOperative {
    
    private func setupDependencies() {
        self.dependencies.register(for: CreditCardRepaymentFormManager.self) { [unowned self] resolver in
            return self.operativeData.formManager
        }
        
        self.setupCreditCardChooseListDependencies()
        self.setupCreditCardRepaymentDetailsDependencies()
        self.setupCreditCardRepaymentConfirmationDependencies()
        self.setupCreditCardRepaymentSummaryDependencies()
    }
    
    private func buildSteps() {
        if formManager.steps.first == .chooseCard {
            self.steps.append(CreditCardChooseListStep(dependenciesResolver: dependencies))
        }
        self.steps.append(CreditCardRepaymentDetailsStep(dependenciesResolver: dependencies))
        self.steps.append(CreditCardRepaymentConfirmationStep(dependenciesResolver: dependencies))
        self.steps.append(CreditCardRepaymentSummaryStep(dependenciesResolver: dependencies))
    }
}

extension CreditCardRepaymentOperative: OperativeSetupCapable {
    
    func performSetup(success: @escaping () -> Void, failed: @escaping (OperativeSetupError) -> Void) {
        let useCase = self.dependencies.resolve(for: CreateCreditCardRepaymentFormUseCaseProtocol.self)
        let requestedValue = CreateCreditCardRepaymentFormUseCaseOkInput(accountNumber: operativeData.creditCardAccountNumber)
        Scenario(useCase: useCase, input: requestedValue)
            .execute(on: dependencies.resolve())
            .onSuccess { [weak self] output in
                guard let self = self else { return }
                self.formManager.initialSetup(
                    form: output.form,
                    steps: output.steps,
                    accountSelectionPossible: output.accountSelectionPossible,
                    currency: output.currency
                )
                self.buildSteps()
                success()
            }
            .onError { error in
                failed(OperativeSetupError(title: nil, message: error.getErrorDesc()))
            }
    }
}

extension CreditCardRepaymentOperative: OperativeFinishingCoordinatorCapable {}

// MARK: - Setup Dependencies for each step / scene

private extension CreditCardRepaymentOperative {
    func setupCreditCardChooseListDependencies() {
         
        self.dependencies.register(for: CreditCardChooseListPresenterProtocol.self) { resolver in
            return CreditCardChooseListPresenter(dependenciesResolver: resolver)
        }
        
        self.dependencies.register(for: GetCreditCardsUseCase.self) { resolver in
            return GetCreditCardsUseCase(dependenciesResolver: resolver)
        }
         
        self.dependencies.register(for: CreditCardChooseListViewProtocol.self) { resolver in
            let presenter = resolver.resolve(for: CreditCardChooseListPresenterProtocol.self)
            let viewController = CreditCardChooseListViewController(presenter: presenter)
            presenter.view = viewController
            return viewController
        }
    }
    
    func setupCreditCardRepaymentDetailsDependencies() {
        self.dependencies.register(for: CreditCardRepaymentDetailsPresenterProtocol.self) { resolver in
            return CreditCardRepaymentDetailsPresenter(dependenciesResolver: resolver)
        }
         
        self.dependencies.register(for: CreditCardRepaymentDetailsViewProtocol.self) { resolver in
            let presenter = resolver.resolve(for: CreditCardRepaymentDetailsPresenterProtocol.self)
            let viewController = CreditCardRepaymentDetailsViewController(presenter: presenter)
            presenter.view = viewController
            return viewController
        }
    }
    
    func setupCreditCardRepaymentConfirmationDependencies() {
        self.dependencies.register(for: CreditCardRepaymentConfirmationPresenterProtocol.self) { resolver in
            return CreditCardRepaymentConfirmationPresenter(dependenciesResolver: resolver)
        }
        
        self.dependencies.register(for: SendCreditCardRepaymentUseCase.self) { resolver in
            return SendCreditCardRepaymentUseCase(dependenciesResolver: resolver)
        }
         
        self.dependencies.register(for: CreditCardRepaymentConfirmationViewProtocol.self) { resolver in
            let presenter = resolver.resolve(for: CreditCardRepaymentConfirmationPresenterProtocol.self)
            let viewController = CreditCardRepaymentConfirmationViewController(presenter: presenter)
            presenter.view = viewController
            return viewController
        }
    }
    
    func setupCreditCardRepaymentSummaryDependencies() {
        self.dependencies.register(for: CreditCardRepaymentSummaryPresenterProtocol.self) { resolver in
            CreditCardRepaymentSummaryPresenter(dependenciesResolver: resolver)
        }
        self.dependencies.register(for: OperativeSummaryViewProtocol.self) { resolver in
            resolver.resolve(for: OperativeSummaryViewController.self)
        }
        self.dependencies.register(for: OperativeSummaryViewController.self) { resolver in
            let presenter = resolver.resolve(for: CreditCardRepaymentSummaryPresenterProtocol.self)
            let viewController = OperativeSummaryViewController(presenter: presenter)
            presenter.view = viewController
            return viewController
        }
    }
}

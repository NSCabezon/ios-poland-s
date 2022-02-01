//
//  TaxTransferFormCoordinator.swift
//  TaxTransfer
//
//  Created by 185167 on 01/12/2021.
//

import UI
import CoreFoundationLib
import CoreDomain
import CoreFoundationLib
import PLCommons
import PLCommonOperatives
import SANPLLibrary
import PLUI

public protocol TaxTransferFormCoordinatorProtocol: ModuleCoordinator {
    func showAccountSelector(
        with accounts: [AccountForDebit],
        selectedAccountNumber: String?,
        mode: AccountForDebitSelectorMode
    )
    func back()
    func backToForm()
    func goToGlobalPosition()
    func didTapPayerSelectorView(with taxPayer: TaxPayer?)
    func didSelectTaxPayer(_ taxPayer: TaxPayer, selectedPayerInfo: SelectedTaxPayerInfo)
    func showTaxPayerSelector(_ taxPayer: TaxPayer, selectedPayerInfo: SelectedTaxPayerInfo)
    func showPayerIdentifiers(for taxPayer: TaxPayer)
}

public final class TaxTransferFormCoordinator: ModuleCoordinator {
    public weak var navigationController: UINavigationController?
    private let dependenciesEngine: DependenciesDefault
    private weak var accountSelectorDelegate: AccountForDebitSelectorDelegate?
    
    private lazy var taxFormPresenter = dependenciesEngine.resolve(for: TaxTransferFormPresenterProtocol.self)

    public init(
        dependenciesResolver: DependenciesResolver,
        navigationController: UINavigationController?
    ) {
        self.navigationController = navigationController
        self.dependenciesEngine = DependenciesDefault(father: dependenciesResolver)
        setUpDependencies()
    }
    
    public func start() {
        let controller = TaxTransferFormViewController(presenter: taxFormPresenter)
        taxFormPresenter.view = controller
        accountSelectorDelegate = taxFormPresenter
        self.navigationController?.pushViewController(controller, animated: true)
    }
}

extension TaxTransferFormCoordinator: TaxTransferFormCoordinatorProtocol {
    public func showAccountSelector(
        with accounts: [AccountForDebit],
        selectedAccountNumber: String?,
        mode: AccountForDebitSelectorMode
    ) {
        guard let delegate = accountSelectorDelegate else { return }
        let coordinator = AccountForDebitSelectorCoordinator(
            dependenciesResolver: dependenciesEngine,
            navigationController: navigationController,
            mode: mode,
            accounts: accounts,
            screenLocationConfiguration: .taxTransfer,
            selectedAccountNumber: selectedAccountNumber,
            accountSelectorDelegate: delegate
        )
        coordinator.start()
    }
    
    public func showTaxPayerSelector(_ taxPayer: TaxPayer, selectedPayerInfo: SelectedTaxPayerInfo) {
        taxFormPresenter.didSelectTaxPayer(taxPayer, selectedPayerInfo: selectedPayerInfo)
        backToForm()
    }
    
    public func showPayerIdentifiers(for taxPayer: TaxPayer) {
        let presenter = TaxTransferPayerIdentifiersPresenter(dependenciesResolver: dependenciesEngine)
        let viewModel = TaxTransferPayerIdentifiersViewModel(taxPayer: taxPayer)
        let viewController = TaxTransferPayerIdentifiersViewController(
            presenter: presenter,
            viewModel: viewModel
        )
        presenter.view = viewController
        
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    public func didSelectTaxPayer(_ taxPayer: TaxPayer, selectedPayerInfo: SelectedTaxPayerInfo) {
        taxFormPresenter.didSelectTaxPayer(taxPayer, selectedPayerInfo: selectedPayerInfo)
        back()
    }
    
    public func didTapPayerSelectorView(with taxPayer: TaxPayer?) {
        let presenter = TaxTransferPayersListPresenter(dependenciesResolver: dependenciesEngine)
        let mapper = dependenciesEngine.resolve(for: TaxPayerViewModelMapping.self)
        let viewModel = TaxTransferPayersListViewModel(mapper: mapper)
        let viewController = TaxTransferPayersListViewController(
           presenter: presenter,
           viewModel: viewModel
        )
        presenter.view = viewController
        viewController.set(selectedTaxPayer: taxPayer)
        
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    public func backToForm() {
        guard let formViewController = navigationController?.viewControllers.first(where: { $0 is TaxTransferFormViewController }) else { return }
        navigationController?.popToViewController(formViewController, animated: true)
    }
    
    public func back() {
        navigationController?.popViewController(animated: true)
    }
    
    public func goToGlobalPosition() {
        navigationController?.popToRootViewController(animated: true)
    }
}

private extension TaxTransferFormCoordinator {
    func setUpDependencies() {
        let amountFormatter = NumberFormatter.PLAmountNumberFormatterWithoutCurrency
        
        dependenciesEngine.register(for: TaxTransferFormCoordinatorProtocol.self) { _ in
            return self
        }
        
        dependenciesEngine.register(for: TaxTransferFormPresenterProtocol.self) { resolver in
            return TaxTransferFormPresenter(
                currency: CurrencyType.złoty.name,
                dependenciesResolver: resolver
            )
        }
        
        dependenciesEngine.register(for: TaxFormConfiguration.self) { resolver in
            return TaxFormConfiguration(
                amountField: .init(
                    amountFormatter: amountFormatter
                ),
                dateSelector: .init(
                    language: resolver.resolve(for: StringLoader.self).getCurrentLanguage().appLanguageCode,
                    dateFormatter: PLTimeFormat.ddMMyyyyDotted.createDateFormatter()
                )
            )
        }
        
        dependenciesEngine.register(for: TaxTransferFormValidating.self) { _ in
            return TaxTransferFormValidator(
                amountFormatter: amountFormatter
            )
        }
        
        dependenciesEngine.register(for: GetAccountsForDebitProtocol.self) { resolver in
            return GetAccountsForDebitUseCase(
                transactionType: .taxTransfer,
                dependenciesResolver: resolver
            )
        }

        dependenciesEngine.register(for: TaxTransferAccountViewModelMapping.self) { _ in
            return TaxTransferAccountViewModelMapper(amountFormatter: .PLAmountNumberFormatter)
        }
        
        dependenciesEngine.register(for: TaxPayerViewModelMapping.self) { _ in
            return TaxPayerViewModelMapper()
        }
        
        dependenciesEngine.register(for: ConfirmationDialogProducing.self) { _ in
            return ConfirmationDialogFactory()
        }
        
        dependenciesEngine.register(for: GetTaxPayersListUseCaseProtocol.self) { resolver in
            return GetTaxPayersListUseCase(dependenciesResolver: resolver)
        }
        
        dependenciesEngine.register(for: TaxPayersMapping.self) { _ in
            return TaxPayersMapper()
        }
    }
}

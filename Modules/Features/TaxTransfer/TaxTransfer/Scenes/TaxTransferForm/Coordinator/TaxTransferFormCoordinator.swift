//
//  TaxTransferFormCoordinator.swift
//  TaxTransfer
//
//  Created by 185167 on 01/12/2021.
//

import UI
import CoreFoundationLib
import CoreDomain
import PLCommons
import PLCommonOperatives
import SANPLLibrary
import PLUI

public protocol TaxTransferFormCoordinatorProtocol: ModuleCoordinator {
    func back()
    func goToGlobalPosition()

    func showTaxPayerSelector(
        with taxPayers: [TaxPayer],
        selectedTaxPayer: TaxPayer?
    )
    func showAccountSelector(
        with accounts: [AccountForDebit],
        selectedAccountNumber: String?,
        mode: AccountForDebitSelectorMode
    )
}

public final class TaxTransferFormCoordinator: ModuleCoordinator {
    public weak var navigationController: UINavigationController?
    private let dependenciesEngine: DependenciesDefault
    private weak var accountSelectorDelegate: AccountForDebitSelectorDelegate?
    private weak var taxPayerSelectorDelegate: TaxPayerSelectorDelegate?

    public init(
        dependenciesResolver: DependenciesResolver,
        navigationController: UINavigationController?
    ) {
        self.navigationController = navigationController
        self.dependenciesEngine = DependenciesDefault(father: dependenciesResolver)
        setUpDependencies()
    }
    
    public func start() {
        let taxFormPresenter = dependenciesEngine.resolve(for: TaxTransferFormPresenterProtocol.self)
        let controller = TaxTransferFormViewController(presenter: taxFormPresenter)
        taxFormPresenter.view = controller
        accountSelectorDelegate = taxFormPresenter
        taxPayerSelectorDelegate = taxFormPresenter
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
    
    public func showTaxPayerSelector(with taxPayers: [TaxPayer], selectedTaxPayer: TaxPayer?) {
        let coordinator = TaxPayersListCoordinator(
            dependenciesResolver: dependenciesEngine,
            taxPayers: taxPayers,
            taxPayerSelectorDelegate: taxPayerSelectorDelegate,
            selectedTaxPayer: selectedTaxPayer,
            navigationController: navigationController
        )
        coordinator.start()
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
        
        dependenciesEngine.register(for: TaxTransferFormDataProviding.self) { resolver in
            return TaxTransferFormDataProvider(dependenciesResolver: resolver)
        }
        
        dependenciesEngine.register(for: TaxTransferAccountViewModelMapping.self) { _ in
            return TaxTransferAccountViewModelMapper(amountFormatter: .PLAmountNumberFormatter)
        }
        
        dependenciesEngine.register(for: SourceAccountsStateMapping.self) { _ in
            return SourceAccountsStateMapper()
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
        
        dependenciesEngine.register(for: TaxAuthorityMapping.self) { _ in
            return TaxAuthorityMapper()
        }
        
        dependenciesEngine.register(for: GetPredefinedTaxAuthoritiesUseCaseProtocol.self) { resolver in
            return GetPredefinedTaxAuthoritiesUseCase(dependenciesResolver: resolver)
        }

        dependenciesEngine.register(for: TaxPayerViewModelMapping.self) { _ in
            return TaxPayerViewModelMapper()
        }
    }
}

//
//  TaxTransferFormCoordinator.swift
//  TaxTransfer
//
//  Created by 185167 on 01/12/2021.
//

import UI
import CoreFoundationLib
import CoreDomain
import Commons
import PLCommons
import PLCommonOperatives
import SANPLLibrary

public protocol TaxTransferFormCoordinatorProtocol: ModuleCoordinator {
    func showAccountSelector(
        with accounts: [AccountForDebit],
        selectedAccountNumber: String?,
        mode: AccountForDebitSelectorMode
    )
    func back()
}

public final class TaxTransferFormCoordinator: ModuleCoordinator {
    public weak var navigationController: UINavigationController?
    private let dependenciesEngine: DependenciesDefault
    private weak var accountSelectorDelegate: AccountForDebitSelectorDelegate?

    public init(
        dependenciesResolver: DependenciesResolver,
        navigationController: UINavigationController?
    ) {
        self.navigationController = navigationController
        self.dependenciesEngine = DependenciesDefault(father: dependenciesResolver)
        setUpDependencies()
    }
    
    public func start() {
        let presenter = dependenciesEngine.resolve(for: TaxTransferFormPresenterProtocol.self)
        let controller = TaxTransferFormViewController(presenter: presenter)
        presenter.view = controller
        accountSelectorDelegate = presenter
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
    
    public func back() {
        navigationController?.popViewController(animated: true)
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
    }
}

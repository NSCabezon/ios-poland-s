//
//  AddTaxAuthorityCoordinator.swift
//  TaxTransfer
//
//  Created by 185167 on 15/02/2022.
//

import CoreFoundationLib
import UI
import PLScenes
import PLCommons

enum AddTaxAuthorityEntryPointContext {
    case preselectedTaxAuthority(TaxAuthority)
    case unselectedTaxAuthority
}

protocol AddTaxAuthorityCoordinatorProtocol: ModuleCoordinator {
    func showTaxSymbolSelector(onSelection: @escaping (TaxSymbol) -> Void)
    func showCityNameSelector(
        cities: [TaxAuthorityCity],
        selectedCity: TaxAuthorityCity?,
        onSelection: @escaping (TaxAuthorityCity) -> Void
    )
    func showTaxAccountSelector(
        taxAccounts: [TaxAccount],
        selectedTaxAccount: TaxAccount?,
        onSelection: @escaping (TaxAccount) -> Void
    )
    func back()
    func close()
}

final class AddTaxAuthorityCoordinator: AddTaxAuthorityCoordinatorProtocol {
    weak var navigationController: UINavigationController?
    private let dependenciesEngine: DependenciesDefault
    private let entryPointContext: AddTaxAuthorityEntryPointContext
    private let taxSymbols: [TaxSymbol]

    public init(
        dependenciesResolver: DependenciesResolver,
        navigationController: UINavigationController?,
        entryPointContext: AddTaxAuthorityEntryPointContext,
        taxSymbols: [TaxSymbol]
    ) {
        self.navigationController = navigationController
        self.dependenciesEngine = DependenciesDefault(father: dependenciesResolver)
        self.entryPointContext = entryPointContext
        self.taxSymbols = taxSymbols
        setUpDependencies()
    }
    
    func start() {
        let controller = dependenciesEngine.resolve(for: AddTaxAuthorityViewController.self)
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func showTaxSymbolSelector(onSelection: @escaping (TaxSymbol) -> Void) {
        let coordinator = TaxSymbolSelectorCoordinator(
            dependenciesResolver: dependenciesEngine,
            navigationController: navigationController,
            taxSymbols: taxSymbols.sorted { $0.name < $1.name },
            selectedTaxSymbol: nil, // TODO:- Replace mocks with preselected data
            onSelection: onSelection
        )
        coordinator.start()
    }
    
    func showCityNameSelector(
        cities: [TaxAuthorityCity],
        selectedCity: TaxAuthorityCity?,
        onSelection: @escaping (TaxAuthorityCity) -> Void
    ) {
        let coordinator = TaxAuthorityCitySelectorCoordinator(
            dependenciesResolver: dependenciesEngine,
            navigationController: navigationController,
            cities: cities,
            selectedCity: selectedCity,
            onSelection: onSelection
        )
        coordinator.start()
    }
    
    func showTaxAccountSelector(
        taxAccounts: [TaxAccount],
        selectedTaxAccount: TaxAccount?,
        onSelection: @escaping (TaxAccount) -> Void
    ) {
        let coordinator = TaxAccountSelectorCoordinator(
            dependenciesResolver: dependenciesEngine,
            navigationController: navigationController,
            taxAccounts: taxAccounts,
            selectedTaxAccount: selectedTaxAccount,
            onSelection: onSelection
        )
        coordinator.start()
    }
    
    func back() {
        navigationController?.popViewController(animated: true)
    }
    
    func close() {
        navigationController?.popToRootViewController(animated: true)
    }
}

private extension AddTaxAuthorityCoordinator {
    func prepareInitialForm() -> TaxAuthorityForm {
        switch entryPointContext {
        case .unselectedTaxAuthority:
            return .formTypeUnselected
        case let .preselectedTaxAuthority(taxAuthority):
            return prepareInitialForm(for: taxAuthority)
        }
    }
    
    // TODO:- Replace mocks with preselected data
    func prepareInitialForm(for taxAuthority: TaxAuthority) -> TaxAuthorityForm {
        switch taxAuthority.taxAccountType {
        case .IRP:
            let form = IrpTaxAuthorityForm(
                taxSymbol: .init(symbolName: "VAT-7", symbolType: 13, isActive: true, isTimePeriodRequired: true, isFundedFromVatAccount: true, destinationAccountType: .IRP),
                taxAuthorityName: taxAuthority.name,
                accountNumber: taxAuthority.accountNumber
            )
            return .irp(form)
        case .US:
            let taxAccount = TaxAccount(accountNumber: "", address: .init(street: "", city: "", zipCode: ""), accountName: "", taxFormType: 0, validFromDate: Date(), validToDate: Date(), isActive: true)
            let form = UsTaxAuthorityForm(
                taxSymbol: .init(symbolName: "VAT-7", symbolType: 13, isActive: true, isTimePeriodRequired: true, isFundedFromVatAccount: true, destinationAccountType: .IRP),
                city: taxAuthority.address,
                taxAuthorityAccount: taxAccount
            )
            return .us(form)
        }
    }
    
    func setUpDependencies() {
        dependenciesEngine.register(for: AddTaxAuthorityCoordinatorProtocol.self) { _ in
            return self
        }
        
        dependenciesEngine.register(for: AddTaxAuthorityViewModelMapping.self) { _ in
            return AddTaxAuthorityViewModelMapper()
        }
        
        dependenciesEngine.register(for: GetTaxAuthorityCitiesUseCaseProtocol.self) { resolver in
            return GetTaxAuthorityCitiesUseCase(dependenciesResolver: resolver)
        }
        
        dependenciesEngine.register(for: TaxAccountMapping.self) { resolver in
            return TaxAccountMapper(dateFormatter: PLTimeFormat.yyyyMMdd.createDateFormatter())
        }
        
        dependenciesEngine.register(for: GetTaxAccountsUseCaseProtocol.self) { resolver in
            return GetTaxAccountsUseCase(dependenciesResolver: resolver)
        }
        
        dependenciesEngine.register(for: AddTaxAuthorityPresenterProtocol.self) { [prepareInitialForm] resolver in
            return AddTaxAuthorityPresenter(
                dependenciesResolver: resolver,
                initialForm: prepareInitialForm()
            )
        }
        
        dependenciesEngine.register(for: AddTaxAuthorityViewController.self) { resolver in
            var presenter = resolver.resolve(for: AddTaxAuthorityPresenterProtocol.self)
            let controller = AddTaxAuthorityViewController(presenter: presenter)
            presenter.view = controller
            return controller
        }
    }
}

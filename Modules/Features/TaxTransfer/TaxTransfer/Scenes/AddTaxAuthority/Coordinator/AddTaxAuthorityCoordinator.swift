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
    case preselectedTaxAuthority(SelectedTaxAuthority)
    case unselectedTaxAuthority
}

protocol AddTaxAuthorityCoordinatorProtocol: ModuleCoordinator {
    func showTaxSymbolSelector(
        selectedTaxSymbol: TaxSymbol?,
        onSelection: @escaping (TaxSymbol) -> Void
    )
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
    func handleTaxAuthoritySelection(of selectedTaxAuthority: SelectedTaxAuthority)
    func back()
    func close()
}

final class AddTaxAuthorityCoordinator: AddTaxAuthorityCoordinatorProtocol {
    weak var navigationController: UINavigationController?
    private let dependenciesEngine: DependenciesDefault
    private let entryPointContext: AddTaxAuthorityEntryPointContext
    private let taxSymbols: [TaxSymbol]
    private let onSelect: (SelectedTaxAuthority) -> Void

    public init(
        dependenciesResolver: DependenciesResolver,
        navigationController: UINavigationController?,
        entryPointContext: AddTaxAuthorityEntryPointContext,
        taxSymbols: [TaxSymbol],
        onSelect: @escaping (SelectedTaxAuthority) -> Void
    ) {
        self.navigationController = navigationController
        self.dependenciesEngine = DependenciesDefault(father: dependenciesResolver)
        self.entryPointContext = entryPointContext
        self.taxSymbols = taxSymbols
        self.onSelect = onSelect
        setUpDependencies()
    }
    
    func start() {
        let controller = dependenciesEngine.resolve(for: AddTaxAuthorityViewController.self)
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func showTaxSymbolSelector(
        selectedTaxSymbol: TaxSymbol?,
        onSelection: @escaping (TaxSymbol) -> Void
    ) {
        let coordinator = TaxSymbolSelectorCoordinator(
            dependenciesResolver: dependenciesEngine,
            navigationController: navigationController,
            shouldPopControllerAfterSelection: true,
            taxSymbols: taxSymbols.sorted { $0.name < $1.name },
            selectedTaxSymbol: selectedTaxSymbol,
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
    
    func handleTaxAuthoritySelection(of selectedTaxAuthority: SelectedTaxAuthority) {
        onSelect(selectedTaxAuthority)
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
    
    func prepareInitialForm(for taxAuthority: SelectedTaxAuthority) -> TaxAuthorityForm {
        switch taxAuthority {
        case .predefinedTaxAuthority:
            return .formTypeUnselected
        case let .irpTaxAuthority(selectedData):
            let form = IrpTaxAuthorityForm(
                taxSymbol: selectedData.taxSymbol,
                taxAuthorityName: selectedData.taxAuthorityName,
                accountNumber: selectedData.accountNumber
            )
            return .irp(form)
        case let .usTaxAuthority(selectedData):
            let form = UsTaxAuthorityForm(
                taxSymbol: selectedData.taxSymbol,
                city: selectedData.cityName,
                taxAuthorityAccount: selectedData.taxAuthorityAccount
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
        
        dependenciesEngine.register(for: SelectedTaxAuthorityMapping.self) { _ in
            return SelectedTaxAuthorityMapper()
        }
        
        dependenciesEngine.register(for: TaxAccountTypeRecognizing.self) { _ in
            return TaxAccountTypeRecognizer()
        }
        
        dependenciesEngine.register(for: TaxAuthorityFormValidating.self) { resolver in
            return TaxAuthorityFormValidator(
                accountTypeRecognizer: resolver.resolve(for: TaxAccountTypeRecognizing.self)
            )
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

//
//  TaxAuthoritySelectorCoordinator.swift
//  TaxTransfer
//
//  Created by 185167 on 10/03/2022.
//

import CoreFoundationLib
import PLScenes
import UI

protocol TaxAuthoritySelectorCoordinatorProtocol: ModuleCoordinator {}

final class TaxAuthoritySelectorCoordinator: TaxAuthoritySelectorCoordinatorProtocol  {
    weak var navigationController: UINavigationController?
    
    private let dependenciesEngine: DependenciesDefault
    private let taxAuthorities: [TaxAuthority]
    private let selectedTaxAuthority: TaxAuthority?
    
    public init(
        dependenciesResolver: DependenciesResolver,
        navigationController: UINavigationController?,
        taxAuthorities: [TaxAuthority],
        selectedTaxAuthority: TaxAuthority?
    ) {
        self.dependenciesEngine = DependenciesDefault(father: dependenciesResolver)
        self.navigationController = navigationController
        self.taxAuthorities = taxAuthorities
        self.selectedTaxAuthority = selectedTaxAuthority
    }
    
    func start() {
        if taxAuthorities.isEmpty {
            showAddTaxAuthorityForm()
        } else {
            showTaxAuthorityList()
        }
    }
}

private extension TaxAuthoritySelectorCoordinator {
    func showTaxAuthorityList() {
        let viewModelMapper = SelectableTaxAuthorityViewModelMapper()
        let itemsViewModels = taxAuthorities.map { viewModelMapper.map($0, selectedTaxAuthority: selectedTaxAuthority) }
        let selectedItemViewModel: SelectableTaxAuthorityViewModel? = {
            guard let taxAuthority = selectedTaxAuthority else { return nil }
            return viewModelMapper.map(taxAuthority, selectedTaxAuthority: selectedTaxAuthority)
        }()
        let configuration = TaxTransferParticipantConfiguration<SelectableTaxAuthorityViewModel>(
            shouldBackAfterSelectItem: true,
            taxItemSelectorType: .payee,
            items: itemsViewModels,
            selectedItem: selectedItemViewModel
        )
        let taxItemSelectorCoordinator = TaxTransferParticipantSelectorCoordinator<SelectableTaxAuthorityViewModel>(
            configuration: configuration,
            itemSelectionHandler: handleTaxAuthoritySelection,
            buttonActionHandler: showAddTaxAuthorityForm,
            dependenciesResolver: dependenciesEngine,
            navigationController: navigationController
        )
        taxItemSelectorCoordinator.start()
    }
    
    func handleTaxAuthoritySelection(of taxAuthority: SelectableTaxAuthorityViewModel) {
        // TODO:- Finish in TAP-2650
    }
    
    func showAddTaxAuthorityForm() {
        if let selectedTaxAuthority = selectedTaxAuthority {
            showFilledAddTaxAuthorityForm(with: selectedTaxAuthority)
        } else {
            showEmptyAddTaxAuthorityForm()
        }
    }
    
    func showFilledAddTaxAuthorityForm(with selectedTaxAuthority: TaxAuthority) {
        // TODO:- Finish in TAP-2649
    }
    
    func showEmptyAddTaxAuthorityForm() {
        // TODO:- Finish in TAP-2472
    }
}

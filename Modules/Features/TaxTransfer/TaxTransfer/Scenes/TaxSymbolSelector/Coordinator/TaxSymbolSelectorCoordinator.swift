//
//  TaxSymbolSelectorCoordinator.swift
//  TaxTransfer
//
//  Created by 185167 on 17/03/2022.
//


import UI
import CoreFoundationLib
import CoreDomain
import PLCommons
import PLCommonOperatives
import SANPLLibrary
import PLScenes

protocol TaxSymbolSelectorCoordinatorProtocol {}

final class TaxSymbolSelectorCoordinator: TaxSymbolSelectorCoordinatorProtocol {
    private weak var navigationController: UINavigationController?
    private let dependenciesEngine: DependenciesDefault
    private let shouldPopControllerAfterSelection: Bool
    private let taxSymbols: [TaxSymbol]
    private let selectedTaxSymbol: TaxSymbol?
    private let onSelection: (TaxSymbol) -> Void
    
    init(
        dependenciesResolver: DependenciesResolver,
        navigationController: UINavigationController?,
        shouldPopControllerAfterSelection: Bool,
        taxSymbols: [TaxSymbol],
        selectedTaxSymbol: TaxSymbol?,
        onSelection: @escaping (TaxSymbol) -> Void
    ) {
        self.dependenciesEngine = DependenciesDefault(father: dependenciesResolver)
        self.navigationController = navigationController
        self.shouldPopControllerAfterSelection = shouldPopControllerAfterSelection
        self.taxSymbols = taxSymbols
        self.selectedTaxSymbol = selectedTaxSymbol
        self.onSelection = onSelection
    }
    
    func start() {
        let taxSymbols = taxSymbols
            .sorted { $0.name < $1.name }
            .filter { $0.isActive }
        let configuration = ItemSelectorConfiguration<TaxSymbol>(
            navigationTitle: localized("pl_toolbar_formSymbol"),
            searchMode: .enabled(
                .init(
                    searchBarPlaceholderText: localized("generic_placeholder_typeFormSymbol"),
                    emptySearchResultMessage: localized("pl_taxTransfer_text_unableToFindSymbol")
                )
            ),
            sections: [
                .init(
                    sectionTitle: localized("pl_taxTransfer_text_chooseFormSymbol"),
                    items: taxSymbols
                )
            ],
            selectedItem: selectedTaxSymbol,
            shouldPopControllerAfterSelection: shouldPopControllerAfterSelection,
            shouldShowDialogBeforeClose: true
        )
        let coordinator = ItemSelectorCoordinator(
            navigationController: navigationController,
            configuration: configuration,
            itemSelectionHandler: onSelection,
            dependenciesResolver: dependenciesEngine
        )
        coordinator.start()
    }
}

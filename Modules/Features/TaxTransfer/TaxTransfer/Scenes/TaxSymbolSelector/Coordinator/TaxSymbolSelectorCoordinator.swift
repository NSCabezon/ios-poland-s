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
    private let taxSymbols: [TaxSymbol]
    private let selectedTaxSymbol: TaxSymbol?
    private let onSelection: (TaxSymbol) -> Void
    
    init(
        dependenciesResolver: DependenciesResolver,
        navigationController: UINavigationController?,
        taxSymbols: [TaxSymbol],
        selectedTaxSymbol: TaxSymbol?,
        onSelection: @escaping (TaxSymbol) -> Void
    ) {
        self.dependenciesEngine = DependenciesDefault(father: dependenciesResolver)
        self.navigationController = navigationController
        self.taxSymbols = taxSymbols
        self.selectedTaxSymbol = selectedTaxSymbol
        self.onSelection = onSelection
    }
    
    func start() {
        let taxSymbols = taxSymbols
            .sorted { $0.name < $1.name }
            .filter { $0.isActive }
        let configuration = ItemSelectorConfiguration<TaxSymbol>(
            navigationTitle: "#Symbol formularza",
            isSearchEnabled: true,
            sections: [
                .init(
                    sectionTitle: "#Wybierz symbol formularza:",
                    items: taxSymbols
                )
            ],
            selectedItem: nil
        )
        let coordinator = ItemSelectorCoordinator(
            navigationController: navigationController,
            configuration: configuration,
            itemSelectionHandler: onSelection
        )
        coordinator.start()
    }
}

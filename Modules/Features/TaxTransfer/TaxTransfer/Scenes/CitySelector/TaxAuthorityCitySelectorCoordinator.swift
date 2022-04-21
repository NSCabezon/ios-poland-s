//
//  TaxAuthorityCitySelectorCoordinator.swift
//  TaxTransfer
//
//  Created by 185167 on 30/03/2022.
//

import CoreFoundationLib
import UI
import PLScenes
import PLCommons

final class TaxAuthorityCitySelectorCoordinator {
    private weak var navigationController: UINavigationController?
    private let dependenciesEngine: DependenciesDefault
    private let cities: [TaxAuthorityCity]
    private let selectedCity: TaxAuthorityCity?
    private let onSelection: (TaxAuthorityCity) -> Void

    public init(
        dependenciesResolver: DependenciesResolver,
        navigationController: UINavigationController?,
        cities: [TaxAuthorityCity],
        selectedCity: TaxAuthorityCity?,
        onSelection: @escaping (TaxAuthorityCity) -> Void
    ) {
        self.navigationController = navigationController
        self.dependenciesEngine = DependenciesDefault(father: dependenciesResolver)
        self.cities = cities
        self.selectedCity = selectedCity
        self.onSelection = onSelection
    }
    
    func start() {
        let storage = AddTaxAuthorityStorage(dependenciesResolver: dependenciesEngine)
        let lastSelectedCities = (try? storage.getLastSelectedCities()) ?? []
        let configuration = ItemSelectorConfiguration<TaxAuthorityCity>(
            navigationTitle: "#Miasto",
            isSearchEnabled: true,
            sections: getSections(withLastSelectedCities: lastSelectedCities),
            selectedItem: selectedCity
        )
        let coordinator = ItemSelectorCoordinator(
            navigationController: navigationController,
            configuration: configuration,
            itemSelectionHandler: onSelection,
            dependenciesResolver: dependenciesEngine
        )
        coordinator.start()
    }
    
    private func getSections(withLastSelectedCities lastSelectedCities: [TaxAuthorityCity]) -> [ItemSelectorConfiguration<TaxAuthorityCity>.ItemSelectorSection] {
        var sections: [ItemSelectorConfiguration<TaxAuthorityCity>.ItemSelectorSection] = []
        if lastSelectedCities.isNotEmpty {
            sections += [
                .init(
                    sectionTitle: "#Ostatnio wybrane:",
                    items: lastSelectedCities
                )
            ]
        }
        sections += [
            .init(
                sectionTitle: "#Lista:",
                items: cities.sorted(by: { $0.cityName < $1.cityName })
            )
        ]
        return sections
    }
}

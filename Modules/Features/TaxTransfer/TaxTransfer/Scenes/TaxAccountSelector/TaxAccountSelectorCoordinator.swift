//
//  TaxAccountSelectorCoordinator.swift
//  TaxTransfer
//
//  Created by 185167 on 30/03/2022.
//

import CoreFoundationLib
import UI
import PLScenes
import PLCommons

final class TaxAccountSelectorCoordinator {
    private weak var navigationController: UINavigationController?
    private let dependenciesEngine: DependenciesDefault
    private let taxAccounts: [TaxAccount]
    private let selectedTaxAccount: TaxAccount?
    private let onSelection: (TaxAccount) -> Void

    public init(
        dependenciesResolver: DependenciesResolver,
        navigationController: UINavigationController?,
        taxAccounts: [TaxAccount],
        selectedTaxAccount: TaxAccount?,
        onSelection: @escaping (TaxAccount) -> Void
    ) {
        self.navigationController = navigationController
        self.dependenciesEngine = DependenciesDefault(father: dependenciesResolver)
        self.taxAccounts = taxAccounts
        self.selectedTaxAccount = selectedTaxAccount
        self.onSelection = onSelection
    }
    
    func start() {
        let storage = AddTaxAuthorityStorage()
        let lastSelectedTaxAccountNumbers = (try? storage.getLastSelectedTaxAccountNumbers()) ?? []
        let lastSelectedTaxAccounts = lastSelectedTaxAccountNumbers.compactMap { accountNumber -> TaxAccount? in
            return taxAccounts.first { $0.accountNumber == accountNumber }
        }
        let configuration = ItemSelectorConfiguration<TaxAccount>(
            navigationTitle: localized("pl_toolbar_taxAuthority"),
            searchMode: .enabled(
                .init(
                    searchBarPlaceholderText: localized("pl_taxTransfer_placeholder_searchTaxAuthority"),
                    emptySearchResultMessage: localized("pl_taxTransfer_text_unableToFindTaxAutohirty")
                )
            ),
            sections: getSections(withLastSelectedTaxAccounts: lastSelectedTaxAccounts),
            selectedItem: selectedTaxAccount,
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
    
    private func getSections(withLastSelectedTaxAccounts lastSelectedTaxAccounts: [TaxAccount]) -> [ItemSelectorConfiguration<TaxAccount>.ItemSelectorSection] {
        var sections: [ItemSelectorConfiguration<TaxAccount>.ItemSelectorSection] = []
        if lastSelectedTaxAccounts.isNotEmpty {
            sections += [
                .init(
                    sectionTitle: localized("generic_label_recentlySelected"),
                    items: lastSelectedTaxAccounts
                )
            ]
        }
        let taxAccounts = taxAccounts
            .filter { $0.isActive }
            .sorted { $0.accountName < $1.accountName }
        sections += [
            .init(
                sectionTitle: localized("generic_label_list"),
                items: taxAccounts
            )
        ]
        return sections
    }
}

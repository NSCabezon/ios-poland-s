//
//  ItemSelectorPresenter.swift
//  PLScenes
//
//  Created by 185167 on 10/02/2022.
//

import CoreFoundationLib
import PLUI

final class ItemSelectorPresenter<Item: SelectableItem> {
    weak var view: ItemSelectorView?
    
    private let coordinator: ItemSelectorCoordinator<Item>
    private let navigationTitle: String
    private let isSearchEnabled: Bool
    private let sectionViewModels: [SelectableItemSectionViewModel<Item>]
    private let configuration: ItemSelectorConfiguration<Item>
    private let dependenciesResolver: DependenciesResolver
    
    init(
        coordinator: ItemSelectorCoordinator<Item>,
        configuration: ItemSelectorConfiguration<Item>,
        viewModelMapper: SelectableItemSectionViewModelMapper<Item>,
        dependenciesResolver: DependenciesResolver
    ) {
        self.coordinator = coordinator
        self.navigationTitle = configuration.navigationTitle
        self.isSearchEnabled = configuration.isSearchEnabled
        self.sectionViewModels = viewModelMapper.map(configuration)
        self.configuration = configuration
        self.dependenciesResolver = dependenciesResolver
    }
    
    func getNavigationTitle() -> String {
        return navigationTitle
    }
    
    func shouldDisableSearch() -> Bool {
        return !isSearchEnabled
    }
    
    func getViewModels(filteredBy filter: SelectableItemFilter) -> [SelectableItemSectionViewModel<Item>] {
        switch filter {
        case .unfiltered:
            return sectionViewModels
        case let .text(searchPhrase):
            return getFilteredViewModels(with: searchPhrase)
        }
    }
    
    func didSelectItem(_ item: Item) {
        coordinator.handleItemSelection(item)
    }
    
    func didTapBack() {
        coordinator.back()
    }
    
    func didTapClose() {
        if configuration.shouldShowDialogBeforeClose {
            let closeConfirmationDialog = confirmationDialogFactory.createEndProcessDialog(
                confirmAction: { [weak self] in
                    self?.coordinator.close()
                },
                declineAction: {}
            )
            view?.showDialog(closeConfirmationDialog)
        } else {
            coordinator.close()
        }
    }
}

private extension ItemSelectorPresenter {
    var confirmationDialogFactory: ConfirmationDialogProducing {
        return dependenciesResolver.resolve()
    }
    
    func getFilteredViewModels(with searchPhrase: String) -> [SelectableItemSectionViewModel<Item>] {
        return sectionViewModels.compactMap { section -> SelectableItemSectionViewModel<Item>? in
            let filteredItemViewModels = section.itemViewModels.filter {
                $0.itemName.lowercased().contains(searchPhrase.lowercased())
            }
            
            if filteredItemViewModels.isEmpty {
                return nil
            } else {
                return SelectableItemSectionViewModel<Item>(
                    sectionTitle: section.sectionTitle,
                    itemViewModels: filteredItemViewModels
                )
            }
        }
    }
}

//
//  ItemSelectorPresenter.swift
//  PLScenes
//
//  Created by 185167 on 10/02/2022.
//

final class ItemSelectorPresenter<Item: SelectableItem> {
    private let coordinator: ItemSelectorCoordinator<Item>
    private let navigationTitle: String
    private let isSearchEnabled: Bool
    private let sectionViewModels: [SelectableItemSectionViewModel<Item>]
    
    init(
        coordinator: ItemSelectorCoordinator<Item>,
        configuration: ItemSelectorConfiguration<Item>,
        viewModelMapper: SelectableItemSectionViewModelMapper<Item>
    ) {
        self.coordinator = coordinator
        self.navigationTitle = configuration.navigationTitle
        self.isSearchEnabled = configuration.isSearchEnabled
        self.sectionViewModels = viewModelMapper.map(configuration)
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
        coordinator.close()
    }
    
    private func getFilteredViewModels(with searchPhrase: String) -> [SelectableItemSectionViewModel<Item>] {
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

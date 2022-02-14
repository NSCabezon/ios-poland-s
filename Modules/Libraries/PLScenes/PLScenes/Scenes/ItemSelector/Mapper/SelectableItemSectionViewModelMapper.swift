//
//  SelectableItemSectionViewModelMapper.swift
//  PLScenes
//
//  Created by 185167 on 10/02/2022.
//

final class SelectableItemSectionViewModelMapper<Item: SelectableItem> {
    func map(_ configuration: ItemSelectorConfiguration<Item>) -> [SelectableItemSectionViewModel<Item>] {
        return configuration.sections.map { section -> SelectableItemSectionViewModel<Item> in
            return SelectableItemSectionViewModel<Item>(
                sectionTitle: section.sectionTitle,
                itemViewModels: section.items.map {
                    mapItemViewModel(
                        item: $0,
                        selectedItem: configuration.selectedItem
                    )
                }
            )
        }
    }
    
    private func mapItemViewModel(item: Item, selectedItem: Item?) -> SelectableItemViewModel<Item> {
        let isItemSelected: Bool = {
            guard let selectedItem = selectedItem else {
                return false
            }
            return
                item.identifier == selectedItem.identifier &&
                item.name == selectedItem.name
        }()
        
        return SelectableItemViewModel<Item>(
            identifier: item.identifier,
            itemName: item.name,
            isSelected: isItemSelected,
            item: item
        )
    }
}

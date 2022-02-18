//
//  TaxItemSelectorViewModelMapper.swift
//  Account
//
//  Created by 187831 on 16/02/2022.
//

import PLScenes

final class TaxItemSelectorViewModelMapper<Item: SelectableItem> {
    func map(_ configuration: TaxItemSelectorConfiguration<Item>) -> TaxItemSelectorViewModel<Item> {
        let taxItemViewModels = configuration.items.map {
            return TaxItemViewModel(
                isSelected: isSelected(item: $0, selectedItem: configuration.selectedItem),
                item: $0
            )
        }
        
        return TaxItemSelectorViewModel(viewModels: taxItemViewModels)
    }
    
    private func isSelected(item: Item, selectedItem: Item?) -> Bool {
        guard let selectedItem = selectedItem else {
            return false
        }
        
        return item.identifier == selectedItem.identifier &&
            item.name == item.name
    }
}

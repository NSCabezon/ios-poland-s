//
//  ItemSelectorViewModel.swift
//  PLUI
//
//  Created by 185167 on 04/02/2022.
//

public struct ItemSelectorViewModel<Item> {
    public let navigationTitle: String
    public let headerText: String
    public let itemViewModels: [ItemViewModel<Item>]
    
    public init(
        navigationTitle: String,
        headerText: String,
        itemViewModels: [ItemViewModel<Item>]
    ) {
        self.navigationTitle = navigationTitle
        self.headerText = headerText
        self.itemViewModels = itemViewModels
    }
}

public struct ItemViewModel<Item> {
    public let itemName: String
    public let isSelected: Bool
    public let item: Item
    
    public init(
        itemName: String,
        isSelected: Bool,
        item: Item
    ) {
        self.itemName = itemName
        self.isSelected = isSelected
        self.item = item
    }
}

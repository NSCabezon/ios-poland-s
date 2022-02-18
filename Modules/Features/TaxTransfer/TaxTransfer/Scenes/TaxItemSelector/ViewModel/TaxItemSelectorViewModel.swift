//
//  TaxItemSelectorViewModel.swift
//  TaxTransfer
//
//  Created by 187831 on 10/02/2022.
//

struct TaxItemSelectorViewModel<Item> {
    let viewModels: [TaxItemViewModel<Item>]
}

struct TaxItemViewModel<Item> {
    let isSelected: Bool
    let item: Item
}

struct TaxItemSelectorConfiguration<Item> {
    let taxItemSelectorType: TaxItemSelectorType
    let items: [Item]
    let selectedItem: Item?
}

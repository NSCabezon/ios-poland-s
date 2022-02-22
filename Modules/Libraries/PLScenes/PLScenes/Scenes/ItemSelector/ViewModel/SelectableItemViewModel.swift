//
//  SelectableItemViewModel.swift
//  PLScenes
//
//  Created by 185167 on 04/02/2022.
//

struct SelectableItemViewModel<Item> {
    let identifier: String
    let itemName: String
    let isSelected: Bool
    let item: Item
}

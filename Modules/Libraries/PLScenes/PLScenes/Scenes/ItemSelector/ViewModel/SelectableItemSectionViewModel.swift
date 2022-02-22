//
//  SelectableItemSectionViewModel.swift
//  PLScenes
//
//  Created by 185167 on 10/02/2022.
//

struct SelectableItemSectionViewModel<Item> {
    let sectionTitle: String
    let itemViewModels: [SelectableItemViewModel<Item>]
}

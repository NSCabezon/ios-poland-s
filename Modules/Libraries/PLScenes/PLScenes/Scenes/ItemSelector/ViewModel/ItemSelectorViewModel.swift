//
//  ItemSelectorViewModel.swift
//  PLScenes
//
//  Created by 185167 on 19/04/2022.
//

enum ItemSelectorViewModel<Item> {
    case sections([SelectableItemSectionViewModel<Item>])
    case emptySearchResultMessage(EmptySearchResultMessageViewModel)
    
    struct EmptySearchResultMessageViewModel {
        let titleMessage: String
    }
}

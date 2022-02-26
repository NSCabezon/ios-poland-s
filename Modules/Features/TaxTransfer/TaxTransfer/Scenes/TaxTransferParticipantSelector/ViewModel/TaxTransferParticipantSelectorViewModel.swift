//
//  TaxItemSelectorViewModel.swift
//  TaxTransfer
//
//  Created by 187831 on 10/02/2022.
//

import PLScenes

struct TaxTransferParticipantSelectorViewModel<Item> {
    let shouldBackAfterSelectItem: Bool
    let viewModels: [TaxTransferParticipantViewModel<Item>]
}

struct TaxTransferParticipantViewModel<Item> {
    let isSelected: Bool
    let item: Item
}

struct TaxTransferParticipantConfiguration<Item: SelectableItem> {
    let shouldBackAfterSelectItem: Bool
    let taxItemSelectorType: TaxTransferParticipantSelectorType
    let items: [Item]
    let selectedItem: Item?
}

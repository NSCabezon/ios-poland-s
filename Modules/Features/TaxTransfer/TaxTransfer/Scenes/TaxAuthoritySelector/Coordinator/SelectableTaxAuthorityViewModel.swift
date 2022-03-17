//
//  SelectableTaxAuthorityViewModel.swift
//  TaxTransfer
//
//  Created by 185167 on 10/03/2022.
//

import PLScenes

struct SelectableTaxAuthorityViewModel {
    let name: String
    let location: String?
    let accountNumber: String
    let isSelected: Bool
    let taxAuthority: TaxAuthority
}

extension SelectableTaxAuthorityViewModel: SelectableItem {
    var identifier: String {
        return taxAuthority.id
    }
}

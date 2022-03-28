//
//  TaxAuthorityCity.swift
//  TaxTransfer
//
//  Created by 185167 on 17/03/2022.
//

import PLScenes

struct TaxAuthorityCity {
    let cityName: String
}

extension TaxAuthorityCity: SelectableItem {
    var name: String {
        return cityName
    }
    
    var identifier: String {
        return cityName
    }
}

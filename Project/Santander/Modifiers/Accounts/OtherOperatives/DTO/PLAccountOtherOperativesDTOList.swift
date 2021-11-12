//
//  PLAccountOtherOperativesDTOList.swift
//  Santander
//
//  Created by Julio Nieto Santiago on 7/10/21.
//

import Foundation

struct PLAccountOtherOperativesDTOList: Codable {
    var accountsOptions, cardsOptions: [PLAccountOtherOperativesDTO]?

    enum CodingKeys: String, CodingKey {
        case accountsOptions = "accounts_options"
        case cardsOptions = "cards_options"
    }
}

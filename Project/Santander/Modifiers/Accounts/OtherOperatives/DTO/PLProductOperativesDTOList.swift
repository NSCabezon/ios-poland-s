//
//  PLProductOperativesDTOList.swift
//  Santander
//
//  Created by Julio Nieto Santiago on 7/10/21.
//

import Foundation

struct PLProductOperativesDTOList: Codable {
    var accountsOptions, cardsOptions, helpCenterOptions, insuranceOptions: [PLProductOperativesDTO]?

    enum CodingKeys: String, CodingKey {
        case accountsOptions = "accounts_options"
        case cardsOptions = "cards_options"
        case helpCenterOptions = "help_center_options"
        case insuranceOptions = "insurance_options"
    }
}

//
//  PLAccountOtherOperativesDTOList.swift
//  Santander
//
//  Created by Julio Nieto Santiago on 7/10/21.
//

import Foundation

struct PLAccountOtherOperativesDTOList: Codable {
    var accountsOptions, cardsOptions: [PLAccountOtherOperativesDTO]?
}

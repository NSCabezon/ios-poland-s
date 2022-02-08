//
//  PLTopUpTransferSettingsDTO.swift
//  Santander
//
//  Created by 188216 on 03/02/2022.
//

import Foundation

struct PLTopUpTransferSettingsDTO: Codable {
    let id: Int
    let defValue: Int
    let reqAcceptance: Bool
}

//
//  CheckPhoneDTO.swift
//  SANPLLibrary
//
//  Created by 188216 on 18/02/2022.
//

import Foundation

public struct CheckPhoneResponseDTO: Codable {
    public let reloadPossible: Bool
    public let result: String
}

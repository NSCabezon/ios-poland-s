//
//  GlobalPositionDTO.swift
//  SANPLLibrary
//
//  Created by Rodrigo Jurado on 13/5/21.
//

import Foundation

public struct GlobalPositionDTO: Codable {
    public let accounts: [AccountDTO]?
    public let cards: [CardDTO]?
    public let deposits: [DepositDTO]?
}

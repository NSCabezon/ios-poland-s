//
//  CardTransactionListDTO.swift
//  SANPLLibrary
//
//  Created by Rubén Muñoz López on 13/8/21.
//

import Foundation

public struct CardTransactionListDTO: Codable {
    public let entries: [CardTransactionDTO]?
}

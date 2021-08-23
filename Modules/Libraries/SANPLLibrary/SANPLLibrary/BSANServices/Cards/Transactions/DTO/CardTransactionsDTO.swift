//
//  CardTransactionsDTO.swift
//  SANPLLibrary
//
//  Created by Rubén Muñoz López on 13/8/21.
//

import Foundation

public struct CardTransactionsDTO: Codable {
    public let cardId: String
    public let cardTransactionsList: [CardTransactionListDTO]?
    public let links: TransactionsLinksDTO
    
    enum CodingKeys: String, CodingKey {
        case cardId, cardTransactionsList
        case links = "_links"
    }
}

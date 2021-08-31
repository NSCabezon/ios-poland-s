//
//  CardTransactionsLinksDTO.swift
//  SANPLLibrary
//
//  Created by Rubén Muñoz López on 13/8/21.
//

import Foundation

public struct CardTransactionsLinksDTO: Codable {
    let statementsListLink: String?
    let first: String?
    let next: String?
    let cardDetailsLink: String?
    
    enum CodingKeys: String, CodingKey {
        case statementsListLink, cardDetailsLink
        case first = "_first"
        case next = "_next"
    }
}

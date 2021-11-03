//
//  CreateChequeRequest.swift
//  BLIK
//
//  Created by Piotr Mielcarzewicz on 14/07/2021.
//

struct CreateChequeRequest: Codable {
    let ticketTime: Int
    let ticketName: String
    let ticketAmount: Decimal
    let ticketCurrency: String
}

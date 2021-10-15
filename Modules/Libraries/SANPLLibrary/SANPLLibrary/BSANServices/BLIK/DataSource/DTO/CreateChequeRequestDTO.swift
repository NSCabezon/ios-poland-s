//
//  CreateChequeRequestDTO.swift
//  SANPLLibrary
//
//  Created by Piotr Mielcarzewicz on 15/07/2021.
//

public struct CreateChequeRequestDTO: Codable {
    let ticketTime: Int
    let ticketName: String
    let ticketAmount: Decimal
    let ticketCurrency: String
    
    public init(
        ticketTime: Int,
        ticketName: String,
        ticketAmount: Decimal,
        ticketCurrency: String
    ) {
        self.ticketTime = ticketTime
        self.ticketName = ticketName
        self.ticketAmount = ticketAmount
        self.ticketCurrency = ticketCurrency
    }
}

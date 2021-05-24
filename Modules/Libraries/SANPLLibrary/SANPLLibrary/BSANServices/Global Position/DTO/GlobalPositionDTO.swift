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
    public let loans: [LoanDTO]?
    public let deposits: [DepositDTO]?
    public let investmentFunds: [InvestmentFundsDTO]?
}

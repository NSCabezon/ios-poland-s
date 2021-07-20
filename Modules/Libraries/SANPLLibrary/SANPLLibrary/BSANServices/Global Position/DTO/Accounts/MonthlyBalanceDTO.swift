//
//  MonthlyBalanceDTO.swift
//  SANPLLibrary
//
//  Created by Rubén Muñoz López on 14/7/21.
//

import Foundation

public struct MonthlyBalanceDTO: Codable, Hashable {
    public let month: String
    public let balance: String
    public let expense: String
    public let income: String
}


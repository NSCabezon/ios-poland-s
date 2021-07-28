//
//  AccountMonthlyBalanceDTO.swift
//  SANPLLibrary
//
//  Created by Rubén Muñoz López on 14/7/21.
//

import Foundation

public struct AccountMonthlyBalanceDTO: Codable {
    public let accountId: String
    public let currencyCode: String
    public let monthlyBalance: [MonthlyBalanceDTO]?
}

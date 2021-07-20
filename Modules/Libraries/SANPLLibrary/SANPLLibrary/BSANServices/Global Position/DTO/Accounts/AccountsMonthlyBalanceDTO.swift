//
//  AccountsMonthlyBalanceDTO.swift
//  SANPLLibrary
//
//  Created by Rubén Muñoz López on 14/7/21.
//

import Foundation

public struct AccountsMonthlyBalanceDTO: Codable {
    public let accountsMonthlyBalance: [AccountMonthlyBalanceDTO]?
}

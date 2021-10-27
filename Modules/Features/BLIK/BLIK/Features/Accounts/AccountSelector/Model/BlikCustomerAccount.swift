//
//  BlikCustomerAccount.swift
//  BLIK
//
//  Created by 185167 on 26/10/2021.
//

import PLCommons

struct BlikCustomerAccount {
    let id: String
    let name: String
    let number: String
    let availableFunds: Money
    let defaultForPayments: Bool
    let defaultForP2P: Bool
}

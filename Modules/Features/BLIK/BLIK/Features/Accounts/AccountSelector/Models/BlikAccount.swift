//
//  BlikAccount.swift
//  BLIK
//
//  Created by 186491 on 22/07/2021.
//

import Foundation
import PLUI
import PLCommons

struct BlikAccount {
    let id: String
    let name: String
    let number: String
    let availableFunds: Money
    let defaultForPayments: Bool
    let type: AccountForDebit.AccountType
    let accountSequenceNumber: Int
    let accountType: Int
}

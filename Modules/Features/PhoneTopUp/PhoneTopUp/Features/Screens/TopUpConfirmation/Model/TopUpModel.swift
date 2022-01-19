//
//  File.swift
//  PhoneTopUp
//
//  Created by 188216 on 17/01/2022.
//

import Foundation
import PLCommons

struct TopUpModel {
    let amount: Decimal
    let account: AccountForDebit
    let recipientNumber: String
    let recipientName: String?
    let date: Date
}

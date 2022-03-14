//
//  File.swift
//  PhoneTopUp
//
//  Created by 188216 on 17/01/2022.
//

import Foundation
import PLCommons

struct TopUpModel {
    let amount: Int
    let account: AccountForDebit
    let topUpAccount: TopUpAccount
    let recipientNumber: String
    let recipientName: String?
    let operatorId: Int
    let date: Date
}

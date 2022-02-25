//
//  AcceptTopUpTransactionUseCaseInput.swift
//  PhoneTopUp
//
//  Created by 188216 on 21/02/2022.
//

import Foundation
import PLCommons

struct PerformTopUpTransactionUseCaseInput {
    let account: AccountForDebit
    let amount: Int
    let recipientNumber: String
    let operatorId: Int
    let date: Date
}

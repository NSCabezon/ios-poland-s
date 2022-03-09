//
//  AcceptTopUpTransactionUseCaseInput.swift
//  PhoneTopUp
//
//  Created by 188216 on 21/02/2022.
//

import Foundation
import PLCommons

struct PerformTopUpTransactionUseCaseInput {
    let sourceAccount: AccountForDebit
    let topUpAccount: TopUpAccount
    let amount: Int
    let recipientNumber: String
    let operatorId: Int
    let date: Date
}

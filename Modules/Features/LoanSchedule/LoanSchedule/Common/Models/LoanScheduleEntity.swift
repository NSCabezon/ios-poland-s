//
//  LoanSchedule.swift
//  LoanSchedule
//
//  Created by 186490 on 31/08/2021.
//

import Foundation
import CoreFoundationLib
import SANLegacyLibrary

struct LoanSchedule {}

extension LoanSchedule {
    struct ScheduleEntity {
        let items: [ItemEntity]
    }

    struct ItemEntity {
        let date: Date // Date format DD-MM-RRRR, more information in [MOBILE-8691]
        let amount: AmountEntity
        let principalAmount: AmountEntity
        let interestAmount: AmountEntity
        let balanceAfterPayment: AmountEntity
    }
}

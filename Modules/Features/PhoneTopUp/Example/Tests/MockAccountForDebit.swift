//
//  MockAccountForDebi.swift
//  PhoneTopUp_Example
//
//  Created by 188216 on 08/03/2022.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation
import PLCommons

extension AccountForDebit {
    static func mockInstance(defaultForPayments: Bool = false) -> Self {
        return AccountForDebit(id: "0", name: "", number: "", availableFunds: Money(amount: 10, currency: "PLN"), defaultForPayments: defaultForPayments, type: .PERSONAL, accountSequenceNumber: 0, accountType: 0, taxAccountNumber: "")
    }
}

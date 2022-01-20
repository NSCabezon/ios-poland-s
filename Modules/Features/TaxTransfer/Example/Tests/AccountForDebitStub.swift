//
//  AccountForDebitStub.swift
//  TaxTransfer_Tests
//
//  Created by 185167 on 13/01/2022.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation
@testable import PLCommons

extension AccountForDebit {
    static func stub(
        id: String = "1",
        name: String = "Konto dla Ciebie",
        number: String = "49102028922276300500000000",
        availableFunds: Money = .init(amount: 10000, currency: "PLN"),
        defaultForPayments: Bool = false,
        type: AccountType = .PERSONAL,
        accountSequenceNumber: Int = 5,
        accountType: Int = 10
    ) -> AccountForDebit {
        return AccountForDebit(
            id: id,
            name: name,
            number: number,
            availableFunds: availableFunds,
            defaultForPayments: defaultForPayments,
            type: type,
            accountSequenceNumber: accountSequenceNumber,
            accountType: accountType
        )
    }
}

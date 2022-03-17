//
//  MockTopUpModel.swift
//  PhoneTopUp_Tests
//
//  Created by 188216 on 08/03/2022.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation
import PLCommons
@testable import PhoneTopUp

extension TopUpModel {
    static func mockInstance() -> TopUpModel {
        return TopUpModel(amount: 10,
                          account: AccountForDebit.mockInstance(),
                          topUpAccount: TopUpAccount.mockInstance(),
                          recipientNumber: "506 765 548",
                          recipientName: "John Doe",
                          operatorId: 0,
                          date: Date())
    }
}

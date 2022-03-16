//
//  MockTopUpPreloadedFormData.swift
//  PhoneTopUp_Tests
//
//  Created by 188216 on 08/03/2022.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation
import PLCommons
@testable import PhoneTopUp

extension TopUpPreloadedFormData {
    static func mockInstance() -> TopUpPreloadedFormData {
        return TopUpPreloadedFormData(accounts: [AccountForDebit.mockInstance(defaultForPayments: true)],
                                      operators: [Operator.mockInstance()],
                                      gsmOperators: [GSMOperator.mockInstance()],
                                      internetContacts: [MobileContact.mockInstance()],
                                      settings: [TopUpOperatorSettings.mockInstance()],
                                      topUpAccount: TopUpAccount.mockInstance())
    }
}

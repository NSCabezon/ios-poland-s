//
//  TopUpPreloadedFormData.swift
//  PhoneTopUp
//
//  Created by 188216 on 03/02/2022.
//

import Foundation
import PLCommons

public struct TopUpPreloadedFormData {
    let accounts: [AccountForDebit]
    let operators: [Operator]
    let internetContacts: [MobileContact]
    let settings: [TopUpOperatorSettings]
    let topUpAccount: TopUpAccount
}

//
//  GetoFormDataOutput.swift
//  PhoneTopUp
//
//  Created by 188216 on 30/11/2021.
//

import Foundation
import PLCommons

public struct GetPhoneTopUpFormDataOutput {
    let accounts: [AccountForDebit]
    let operators: [Operator]
    let internetContacts: [MobileContact]
    let topUpAccount: TopUpAccount
}

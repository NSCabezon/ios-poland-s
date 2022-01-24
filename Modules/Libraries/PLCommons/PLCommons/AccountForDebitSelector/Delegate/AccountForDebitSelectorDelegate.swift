//
//  AccountForDebitSelectorDelegate.swift
//  PhoneTopUp
//
//  Created by 188216 on 26/11/2021.
//

import Foundation
import PLUI

public protocol AccountForDebitSelectorDelegate: AnyObject {
    func didSelectAccount(withAccountNumber accountNumber: String)
}

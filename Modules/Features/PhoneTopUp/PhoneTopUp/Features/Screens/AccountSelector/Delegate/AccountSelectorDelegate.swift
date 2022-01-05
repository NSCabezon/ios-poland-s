//
//  AccountSelectorDelegate.swift
//  PhoneTopUp
//
//  Created by 188216 on 26/11/2021.
//

import Foundation
import PLUI

protocol AccountSelectorDelegate: AnyObject {
    func accountSelectorDidSelectAccount(withAccountNumber accountNumber: String)
}

//
//  TopUpPhoneNumber.swift
//  PhoneTopUp
//
//  Created by 188216 on 16/02/2022.
//

import Foundation
import PLCommons

enum TopUpPhoneNumber {
    case partial(number: String)
    case full(number: String)
    case contact(MobileContact)
    
    var number: String {
        switch self {
        case .partial(let number):
            return number
        case .full(let number):
            return number
        case .contact(let contact):
            return contact.phoneNumberDigits
        }
    }
    
    var fullNumber: String? {
        switch self {
        case .partial(let number):
            return nil
        case .full(let number):
            return number
        case .contact(let contact):
            return contact.phoneNumberDigits
        }
    }
}

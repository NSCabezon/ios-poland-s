//
//  TopUpPhoneNumber.swift
//  PhoneTopUp
//
//  Created by 188216 on 16/02/2022.
//

import Foundation

enum TopUpPhoneNumber {
    case partial(number: String)
    case full(number: String)
    
    var number: String {
        switch self {
        case .partial(let number):
            return number
        case .full(let number):
            return number
        }
    }
}

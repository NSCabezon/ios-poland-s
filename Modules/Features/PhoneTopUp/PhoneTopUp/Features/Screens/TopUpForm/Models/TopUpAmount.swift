//
//  TopUpAmount.swift
//  PhoneTopUp
//
//  Created by 188216 on 08/02/2022.
//

import Foundation

enum TopUpAmount {
    case fixed(TopUpValue)
    case custom(amount: Int?)
    
    var amount: Int? {
        switch self {
        case .fixed(let topUpValue):
            return topUpValue.value
        case .custom(let amount):
            return amount
        }
    }
}

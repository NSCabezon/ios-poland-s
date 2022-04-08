//
//  TopUpValues.swift
//  PhoneTopUp
//
//  Created by 188216 on 17/12/2021.
//

import Foundation

public struct TopUpValues {
    public let type: String
    public let min: Int?
    public let max: Int?
    public let values: [TopUpValue]
    
    public var customAmountEnabled: Bool {
        let customAmountsTypes = ["RANGE_AND_DEFINED_AMOUNT", "RANGE_AMOUNT"]
        return customAmountsTypes.contains(type) && min != nil && max != nil
    }
}

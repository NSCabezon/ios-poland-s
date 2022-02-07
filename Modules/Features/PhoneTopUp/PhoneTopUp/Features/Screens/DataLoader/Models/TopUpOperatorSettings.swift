//
//  TopUpSettings.swift
//  PhoneTopUp
//
//  Created by 188216 on 03/02/2022.
//

import Foundation

public struct TopUpOperatorSettings {
    public let operatorId: Int
    public let defaultTopUpValue: Int
    public let requestAcceptance: Bool
    
    public init(operatorId: Int, defaultTopUpValue: Int, requestAcceptance: Bool) {
        self.operatorId = operatorId
        self.defaultTopUpValue = defaultTopUpValue
        self.requestAcceptance = requestAcceptance
    }
}

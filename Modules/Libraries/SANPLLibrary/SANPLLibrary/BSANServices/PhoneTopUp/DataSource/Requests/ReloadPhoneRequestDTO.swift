//
//  Reload.swift
//  SANPLLibrary
//
//  Created by 188216 on 22/02/2022.
//

import Foundation

public struct ReloadPhoneRequestDTO: Codable {
    
    enum CodingKeys: String, CodingKey {
        case operatorId = "idOperator"
        case topUpNumber = "msisdn"
        case reloadAmount
    }
    
    public let operatorId: Int
    public let topUpNumber: String
    public let reloadAmount: Int
    
    public init(operatorId: Int, topUpNumber: String, reloadAmount: Int) {
        self.operatorId = operatorId
        self.topUpNumber = topUpNumber
        self.reloadAmount = reloadAmount
    }
}

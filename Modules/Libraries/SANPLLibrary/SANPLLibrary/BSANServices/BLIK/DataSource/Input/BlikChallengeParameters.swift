//
//  BlikChallengeParameters.swift
//  SANPLLibrary
//
//  Created by 187830 on 28/04/2022.
//

import Foundation

public struct BlikChallengeParameters: Encodable {
    public let merchantId: String?
    public let time: String
    public let amount: Decimal
    
    public init(merchantId: String?, time: String, amount: Decimal) {
        self.merchantId = merchantId
        self.time = time
        self.amount = amount
    }
}

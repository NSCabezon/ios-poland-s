//
//  CheckTransactionParameters.swift
//  SANPLLibrary
//
//  Created by Adrian Arcalá Ocón on 11/10/21.
//

import Foundation

public struct CheckTransactionParameters: Encodable {
    let customerProfile: String
    let transactionAmount: Decimal
    let hasSplitPayment: Bool?
    
    enum CodingKeys: String, CodingKey {
        case customerProfile = "customer_profile"
        case transactionAmount = "transaction_amount"
        case hasSplitPayment
    }
}

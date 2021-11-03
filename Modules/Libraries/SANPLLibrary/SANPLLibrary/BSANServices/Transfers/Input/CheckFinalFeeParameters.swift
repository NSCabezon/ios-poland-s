//
//  CheckFinalFeeParameters.swift
//  SANPLLibrary
//
//  Created by Jose Javier Montes Romero on 11/10/21.
//

import Foundation

struct CheckFinalFeeParameters: Encodable {
    let serviceIds: String
    let channelId: String
    let operationAmount: Decimal
    let operationCurrency: String
}

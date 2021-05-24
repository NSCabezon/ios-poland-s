//
//  GlobalPositionParameters.swift
//  SANPLLibrary
//
//  Created by Rodrigo Jurado on 14/5/21.
//

import Foundation

public enum GlobalPositionFilterType: String, Encodable {
    case accounts = "ACCOUNTS"
    case cards = "CARDS"
    case loans = "LOANS"
    case deposits = "DEPOSITS"
    case investmentFunds = "INVESTMENTS"
}

public struct GlobalPositionParameters: Encodable {
    let filterBy: GlobalPositionFilterType
}

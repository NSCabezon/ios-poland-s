//
//  CardTransationsParameters.swift
//  SANPLLibrary
//
//  Created by Fernando Sánchez García on 19/8/21.
//

import Foundation

public struct CardTransactionsParameters: Encodable {
    public let cardNo: String

    public init(cardNo: String) {
        self.cardNo = cardNo
    }
}

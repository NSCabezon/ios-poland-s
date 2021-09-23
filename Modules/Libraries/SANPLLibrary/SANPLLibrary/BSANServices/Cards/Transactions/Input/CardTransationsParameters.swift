//
//  CardTransationsParameters.swift
//  SANPLLibrary
//
//  Created by Fernando Sánchez García on 19/8/21.
//

import Foundation

public struct CardTransactionsParameters: Encodable {
    public let cardNo: String
    public let text: String?
    public let from: String?
    public let to: String?
    public let amountFrom: Decimal?
    public let amountTo: Decimal?
    public let debitFlag: String?

    public init(cardNo: String, text: String? = nil, startDate: String? = nil, endDate: String? = nil, amountFrom: Decimal? = nil, amountTo: Decimal? = nil, debitFlag: String? = nil) {
        self.cardNo = cardNo
        self.text = text
        
        if startDate == nil || endDate == nil {
            self.from = nil
            self.to = nil
        } else {
            self.from = startDate
            self.to = endDate
        }
        
        if amountFrom == nil || amountTo == nil {
            self.amountFrom = nil
            self.amountTo = nil
        } else {
            self.amountFrom = amountFrom
            self.amountTo = amountTo
        }
        
        self.debitFlag = debitFlag
    }
}

//
//  AccountTransactionsParameters.swift
//  SANPLLibrary
//
//  Created by Rodrigo Jurado on 22/7/21.
//

import Foundation

public struct AccountTransactionsParameters: Encodable {
    public let accountNumbers: [String]
    public let firstOper: Int?
    public let from: String?
    public let to: String?
    public let state: String?
    public let text: String?
    public let postedFrom: String?
    public let postedTo: String?
    public let amountFrom: Decimal?
    public let amountTo: Decimal?
    public let sortOrder: String?
    public let debitFlag: String?
    public let pagingFirst: String?
    public let pagingLast: String?

    public init(accountNumbers: [String], firstOper: Int? = 100, from: String? = nil, to: String? = nil, state: String? = nil, text: String? = nil, postedFrom: String? = nil, postedTo: String? = nil, amountFrom: Decimal? = nil, amountTo: Decimal? = nil, sortOrder: String? = nil, debitFlag: String? = nil, pagingFirst: String? = nil, pagingLast: String? = nil) {
        self.accountNumbers = accountNumbers
        self.firstOper = firstOper
        self.from = from
        self.to = to
        self.state = state
        self.text = text
        self.postedFrom = postedFrom
        self.postedTo = postedTo
        self.amountFrom = amountFrom
        self.amountTo = amountTo
        self.sortOrder = sortOrder
        self.debitFlag = debitFlag
        self.pagingFirst = pagingFirst
        self.pagingLast = pagingLast
    }
}

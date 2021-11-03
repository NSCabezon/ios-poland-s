//
//  LoanTransactionParameters.swift
//  SANPLLibrary
//

import Foundation

public struct LoanTransactionParameters: Encodable {
    public var dateFrom: String?
    public var dateTo: String?
    public var amountFrom: Decimal?
    public var amountTo: Decimal?
    public var amountOptions: String?
    public var operationCount: Int?
    public var getDirection: Int?

    public init(dateFrom: String? = nil, dateTo: String? = nil, amountFrom: Decimal? = nil, amountTo: Decimal? = nil, amountOptions: String? = nil, operationCount: Int? = 100, getDirection: Int? = 1) {
        self.dateFrom = dateFrom
        self.dateTo = dateTo
        self.amountFrom = amountFrom
        self.amountTo = amountTo
        self.amountOptions = amountOptions
        self.operationCount = operationCount
        self.getDirection = getDirection
    }
}

public enum GetLoanTransactionType: String {
    case byId = "get_by_id"
    case byNumber = "get_by_no"
}

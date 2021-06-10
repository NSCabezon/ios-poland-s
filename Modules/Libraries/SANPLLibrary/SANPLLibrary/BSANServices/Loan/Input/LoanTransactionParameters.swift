//
//  LoanTransactionParameters.swift
//  SANPLLibrary
//

import Foundation

public struct LoanTransactionParameters: Encodable {
    public var dateFrom: String?
    public var dateTo: String?
    public var operationCount: Int?
    public var getDirection: Int?

    public init(dateFrom: String?, dateTo: String?, operationCount: Int?, getDirection: Int?) {
        self.dateFrom = dateFrom
        self.dateTo = dateTo
        self.operationCount = operationCount
        self.getDirection = getDirection
    }
}

public enum GetLoanTransactionType: String {
    case byId = "get_by_id"
    case byNumber = "get_by_no"
}

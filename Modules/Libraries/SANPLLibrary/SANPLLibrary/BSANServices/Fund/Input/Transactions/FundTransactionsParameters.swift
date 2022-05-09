//
//  FundTransactionsParameters.swift
//  Account
//
//  Created by Alberto Talavan Bustos on 25/2/22.
//

import Foundation
import CoreDomain
import CoreFoundationLib

public struct FundTransactionsParameters: Codable {
    public var dateFrom: String?
    public var dateTo: String?
    public var skipNumber: Int?
    public var operationCount: Int?
}

extension FundTransactionsParameters: TransactionFiltersRepresentable {
    public var fromAmount: Decimal? {
        nil
    }

    public var toAmount: Decimal? {
        nil
    }

    public var dateInterval: Foundation.DateInterval? {
        guard let dateFrom = self.dateFrom,
              let dateTo = self.dateTo,
              let startDate = dateFrom.toDate(dateFormat: TimeFormat.yyyyMMdd.rawValue),
              let endDate = dateTo.toDate(dateFormat: TimeFormat.yyyyMMdd.rawValue) else { return nil }
        return Foundation.DateInterval(start: startDate, end: endDate)
    }
}

extension FundTransactionsParameters: Hashable, Equatable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.dateFrom)
        hasher.combine(self.dateTo)
    }

    public static func == (lhs: FundTransactionsParameters, rhs: FundTransactionsParameters) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
}

extension FundTransactionsParameters: PaginationRepresentable {}

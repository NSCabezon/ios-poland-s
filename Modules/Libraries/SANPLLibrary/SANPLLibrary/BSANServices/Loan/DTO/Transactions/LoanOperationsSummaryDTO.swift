//
//  LoanOperationsSummaryDTO.swift
//  SANPLLibrary
//

import Foundation

public struct LoanOperationsSummaryDTO: Codable {
    public let revenuesDebit: Double?
    public let revenuesCredit: Double?
    public let currencyCode: String?
}

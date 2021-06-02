//
//  LoanTransactionDTO.swift
//  SANPLLibrary
//

import Foundation

public struct LoanTransactionDTO: Codable {
    public let interestPayment: Double?
    public let paymentDate: String?
    public let principalBalance: Double?
    public let totalPayment: String?
}

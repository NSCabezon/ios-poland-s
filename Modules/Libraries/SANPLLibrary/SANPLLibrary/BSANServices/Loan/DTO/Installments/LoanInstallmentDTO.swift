//
//  LoanInstallmentDTO.swift
//  SANPLLibrary
//

import Foundation

public struct LoanInstallmentDTO: Codable {
    public let interestPayment: Double?
    public let paymentDate: String?
    public let principalBalance: Double?
    public let totalPayment: String?
}

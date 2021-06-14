//
//  LoanInstallmentPageDTO.swift
//  SANPLLibrary
//

import Foundation

public struct LoanInstallmentPageDTO: Codable {
    public let operationCount: Int?
    public let hasNextPage: Bool?
    public let navigationKey: String?
}

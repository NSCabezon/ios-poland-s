//
//  LoanPageDTO.swift
//  SANPLLibrary
//

import Foundation

public struct LoanPageDTO: Codable {
    public let operationCount: Int?
    public let hasNextPage: Bool?
    public let navigationKey: String?
}

//
//  LoanOperationListDTO.swift
//  SANPLLibrary
//

import Foundation

public struct LoanOperationListDTO: Codable {
    public let operationList: [LoanOperationDTO]?
    public let summary: LoanOperationsSummaryDTO?
}

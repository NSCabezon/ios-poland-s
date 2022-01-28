//
//  LoanOperationListDTO.swift
//  SANPLLibrary
//
import CoreDomain
import Foundation

public struct LoanOperationListDTO: Codable {
    public let operationList: [LoanOperationDTO]?
    public let summary: LoanOperationsSummaryDTO?
}

extension LoanOperationListDTO: LoanResultPageRepresentable {
    public var transactions: [LoanTransactionRepresentable] {
        return operationList ?? []
    }
    
    public var next: PaginationRepresentable? {
        return nil
    }
}

//
//  LoanOperationDTO.swift
//  SANPLLibrary
//

import Foundation

public struct LoanOperationDTO: Codable {
    public let balance: Double?
    public let operationId: LoanOperationIdDTO?
    public let valueDate: String?
    public let amount: Double?
    public let interestAmount: Double?
    public let title: String?
    public let psCode: String?
    public let statementNo: Int?
    public let extraData: LoanOperationExtraDataDTO?
    public let csrData: LoanOperationCsrDataDTO?
}

public struct LoanOperationIdDTO: Codable {
    public let postingDate: String?
    public let operationLP: Int?
}

public struct LoanOperationExtraDataDTO: Codable {
    public let extendedTitle: String?
    public let branchId: Int?
    public let sideDebit: LoanOperationSideDTO?
    public let sideCredit: LoanOperationSideDTO?
    public let operationSubCode: Int?
    public let sepaData: String?
    public let operationType: String?
    public let operationCurrency: String?
}

public struct LoanOperationSideDTO: Codable {
    public let address: String?
    public let accountNo: String?
    public let exchangeRate: String?
}

public struct LoanOperationCsrDataDTO: Codable {
    public let csrId: Int?
    public let csrOperationId: String?
    public let csrReference: String?
}

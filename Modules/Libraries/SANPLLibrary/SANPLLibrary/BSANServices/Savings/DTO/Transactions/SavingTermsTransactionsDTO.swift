//
//  SavingTermsTransactionsDTO.swift
//  SANPLLibrary
//
//  Created by Mario Rosales Maillo on 7/4/22.
//

import Foundation

public struct SavingTermTransactionsDTO: Codable {
    public let operationList: [SavingTermTransactionDTO]?
    public let summary: SavingTermTransactionsSummaryDTO?
}

public struct SavingTermTransactionsSummaryDTO: Codable {
    public let revenuesDebit: Double?
    public let revenuesCredit: Double?
    public let currencyCode: String?
}

public struct SavingTermTransactionDTO: Codable {
    public let balance: Double?
    public let operationId: SavingTermTransactionIdDTO?
    public let dateValue: String?
    public let amount: Double?
    public let interestAmount: Double?
    public let title: String?
    public let psCode: String?
    public let statementNo: Int?
    public let receiptId: String?
    public let extraData: SavingTermTransactionExtraDataDTO?
    public let csrData: SavingTermTransactionCsrDataDTO?
    
    enum CodingKeys: String, CodingKey {
        case balance = "balance"
        case operationId = "operationId"
        case dateValue = "valueDate"
        case amount = "amount"
        case interestAmount = "interestAmount"
        case title = "title"
        case psCode = "psCode"
        case statementNo = "statementNo"
        case receiptId = "receiptId"
        case extraData = "extraData"
        case csrData = "csrData"
    }
}

public struct SavingTermTransactionIdDTO: Codable {
    public let postingDate: String?
    public let operationLP: Int?
}

public struct SavingTermTransactionExtraDataDTO: Codable {
    public let extendedTitle: String?
    public let branchId: Int?
    public let sideDebit: SavingTermTransactionSideDTO?
    public let sideCredit: SavingTermTransactionSideDTO?
    public let operationSubCode: Int?
    public let sepaData: String?
    public let operationType: String?
    public let operationCurrency: String?
}

public struct SavingTermTransactionSideDTO: Codable {
    public let address: String?
    public let accountNo: String?
    public let exchangeRate: String?
}

public struct SavingTermTransactionCsrDataDTO: Codable {
    public let csrId: Int?
    public let csrOperationId: String?
    public let csrReference: String?
}

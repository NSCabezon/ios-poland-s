//
//  LoanTransactionsListDTO.swift
//  SANPLLibrary
//

import Foundation

public struct LoanTransactionsListDTO: Codable {
    public let installments: [LoanTransactionDTO]?
    public let page: LoanPageDTO?
}

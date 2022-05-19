//
//  SavingsTransactionsParameters.swift
//  SANPLLibrary
//
//  Created by Mario Rosales Maillo on 7/4/22.
//
import Foundation

public struct SavingsTransactionsParameters: Encodable {
    public let accountNumbers: [String]
    public var operationCount: Int
    public var getDirection: Int?
    public var firstOper: Int = 10
    public var pagingLast: String?
    
    public init(accountNumbers: [String],
                operationCount: Int = 10,
                getDirection: Int = 1,
                pagingLast: String? = nil ) {
        self.accountNumbers = accountNumbers
        self.operationCount = operationCount
        self.firstOper = operationCount
        self.getDirection = getDirection
        self.pagingLast = pagingLast
    }
}

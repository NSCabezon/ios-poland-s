//
//  FundInfo.swift
//  CoreDomain
//
//  Created by Ernesto Fernandez Calles on 15/3/22.
//

import Foundation
import CoreDomain

public struct FundInfo: Codable {
    public var fundDetailDictionary: [String : FundDetailsDTO] = [:]
    public var fundMovements: [String : [FundTransactionDTO]] = [:]
    public var fundFilteredMovements: [FundFilteredMovement : [FundTransactionDTO]] = [:]
    public var hasMoreMovements: [String : Bool] = [:]
    public var hasMoreFilteredMovements: [FundFilteredMovement : Bool] = [:]
}

public struct FundFilteredMovement: Codable, Hashable {
    public var fund: String
    public var filters: FundTransactionsParameters

    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.fund)
        hasher.combine(self.filters)
    }
}

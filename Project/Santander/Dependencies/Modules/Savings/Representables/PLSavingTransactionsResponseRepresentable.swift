//
//  PLSavingTransactionsResponseRepresentable.swift
//  Santander
//
//  Created by Mario Rosales Maillo on 7/4/22.
//

import Foundation
import CoreDomain

public struct PLSavingTransactionsResponseRepresentable: SavingTransactionsResponseRepresentable {
    public var data: SavingTransactionDataRepresentable
    public var pagination: SavingPaginationRepresentable?
}

public struct PLSavingPaginationRepresentable: SavingPaginationRepresentable {
    public let next: String?
    public let current: String?
    
    init(next: String? = nil, current: String? = nil) {
        self.next = next
        self.current = current
    }
}

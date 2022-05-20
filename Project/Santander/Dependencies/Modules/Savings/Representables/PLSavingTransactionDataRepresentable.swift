//
//  PLSavingTransactionDataRepresentable.swift
//  Santander
//
//  Created by Mario Rosales Maillo on 7/4/22.
//

import Foundation
import CoreDomain
import SANPLLibrary

public struct PLSavingTransactionDataRepresentable: SavingTransactionDataRepresentable {
    public var transactions: [SavingTransactionRepresentable]
    public var accounts: [SavingAccountRepresentable]?
    
    init(dtos: [SavingTransactionDTO]) {
        self.transactions = dtos.map({ dto in
            return PLSavingTransactionRepresentable(dto: dto)
        })
    }
    
    init(termDtos: [SavingTermTransactionDTO]) {
        self.transactions = termDtos.map({ dto in
            return PLSavingTransactionRepresentable(dto: dto)
        })
    }
}

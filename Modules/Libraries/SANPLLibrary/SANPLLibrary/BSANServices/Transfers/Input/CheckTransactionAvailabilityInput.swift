//
//  File.swift
//  SANPLLibrary
//
//  Created by Jose Javier Montes Romero on 11/10/21.
//

import CoreDomain

public struct CheckTransactionAvailabilityInput {
    var destinationAccount: IBANRepresentable
    var transactionAmount: Decimal
    
    public init(destinationAccount: IBANRepresentable, transactionAmount: Decimal) {
        self.destinationAccount = destinationAccount
        self.transactionAmount = transactionAmount
    }
}


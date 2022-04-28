//
//  File.swift
//  SANPLLibrary
//
//  Created by Jose Javier Montes Romero on 11/10/21.
//

import CoreDomain

public struct CheckTransactionAvailabilityInput {
    var destinationAccount: IBANRepresentable
    var transactionAmount: AmountRepresentable?
    
    public init(destinationAccount: IBANRepresentable, transactionAmount: AmountRepresentable?) {
        self.destinationAccount = destinationAccount
        self.transactionAmount = transactionAmount
    }
}


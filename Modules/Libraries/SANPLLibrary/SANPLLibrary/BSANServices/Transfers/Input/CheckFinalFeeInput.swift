//
//  File.swift
//  SANPLLibrary
//
//  Created by Jose Javier Montes Romero on 11/10/21.
//

import CoreDomain

public struct CheckFinalFeeInput {
    var destinationAccount: IBANRepresentable
    var amount: AmountRepresentable

    public init(destinationAccount: IBANRepresentable, amount: AmountRepresentable) {
        self.destinationAccount = destinationAccount
        self.amount = amount
    }
}

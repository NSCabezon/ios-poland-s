//
//  File.swift
//  SANPLLibrary
//
//  Created by Jose Javier Montes Romero on 11/10/21.
//

import CoreDomain

public struct CheckFinalFeeInput {
    var originAccount: IBANRepresentable
    var amount: AmountRepresentable

    public init(originAccount: IBANRepresentable, amount: AmountRepresentable) {
        self.originAccount = originAccount
        self.amount = amount
    }
}

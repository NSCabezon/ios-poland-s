//
//  File.swift
//  SANPLLibrary
//
//  Created by Jose Javier Montes Romero on 11/10/21.
//

import CoreDomain

public struct CheckFinalFeeInput {
    let originAccount: IBANRepresentable
    let amount: AmountRepresentable
    let servicesAvailable: String

    public init(originAccount: IBANRepresentable, amount: AmountRepresentable, servicesAvailable: String) {
        self.originAccount = originAccount
        self.amount = amount
        self.servicesAvailable = servicesAvailable
    }
}

//
//  CheckFinalFeeInput.swift
//  SANPLLibrary_Tests
//
//  Created by Jose Javier Montes Romero on 11/10/21.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import SANPLLibrary

public struct CheckFinalFeeInput: CheckFinalFeeInputRepresentable {
    public var destinationAccountNumber: String
    public var servicesIds: [String]
    public var amount: Decimal
    public var currencyCode: String
    
    internal init(destinationAccountNumber: String, servicesIds: [String], amount: Decimal, currencyCode: String) {
        self.destinationAccountNumber = destinationAccountNumber
        self.servicesIds = servicesIds
        self.amount = amount
        self.currencyCode = currencyCode
    }
}

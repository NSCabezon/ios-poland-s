//
//  PLSavingTransactionBalanceRepresentable.swift
//  Santander
//
//  Created by Mario Rosales Maillo on 7/4/22.
//

import Foundation
import SANPLLibrary
import CoreDomain

public struct PLSavingTransactionBalanceRepresentable: SavingTransactionBalanceRepresentable {
    public let type: String
    public let amount: SavingAmountRepresentable
    public let creditDebitIndicator: String
}

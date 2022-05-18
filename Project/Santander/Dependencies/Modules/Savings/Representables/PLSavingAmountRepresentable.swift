//
//  PLSavingAmountRepresentable.swift
//  Santander
//
//  Created by Mario Rosales Maillo on 7/4/22.
//

import Foundation
import SANPLLibrary
import CoreDomain

public struct PLSavingAmountRepresentable: SavingAmountRepresentable {
    public var amount: String
    public var currency: String
}

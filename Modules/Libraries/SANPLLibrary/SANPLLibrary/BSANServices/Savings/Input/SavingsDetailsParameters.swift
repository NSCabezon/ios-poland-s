//
//  SavingsDetailsParameters.swift
//  SANPLLibrary
//
//  Created by Marcos Álvarez Mesa on 30/4/22.
//

import Foundation

public struct SavingsDetailsParameters: Encodable {
    public let accountNumber: String

    public init(accountNumbers: String) {
        self.accountNumber = accountNumbers
    }
}

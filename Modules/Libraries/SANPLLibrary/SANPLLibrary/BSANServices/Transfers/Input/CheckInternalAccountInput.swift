//
//  CheckInternalAccountInput.swift
//  SANPLLibrary
//
//  Created by Jose Javier Montes Romero on 11/10/21.
//

import CoreDomain

public struct CheckInternalAccountInput {
    var destinationAccount: IBANRepresentable

    public init(destinationAccount: IBANRepresentable) {
        self.destinationAccount = destinationAccount
    }
}

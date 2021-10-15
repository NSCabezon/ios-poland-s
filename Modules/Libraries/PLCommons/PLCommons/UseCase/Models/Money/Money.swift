//
//  Money.swift
//  BLIK
//
//  Created by Piotr Mielcarzewicz on 24/06/2021.
//

public struct Money: Equatable {
    public let amount: Decimal
    public let currency: String

    public init(amount: Decimal, currency: String) {
        self.amount = amount
        self.currency = currency
    }
}

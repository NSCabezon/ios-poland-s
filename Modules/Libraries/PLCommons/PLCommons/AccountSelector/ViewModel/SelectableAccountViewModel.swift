//
//  SelectableAccountViewModel.swift
//  BLIK
//
//  Created by Piotr Mielcarzewicz on 29/07/2021.
//

public struct SelectableAccountViewModel {
    public let name: String
    public let accountNumber: String
    public let accountNumberUnformatted: String
    public let availableFunds: String
    public var isSelected: Bool
    
    public init(name: String,
                accountNumber: String,
                accountNumberUnformatted: String,
                availableFunds: String,
                isSelected: Bool) {
        self.name = name
        self.accountNumber = accountNumber
        self.accountNumberUnformatted = accountNumberUnformatted
        self.availableFunds = availableFunds
        self.isSelected = isSelected
    }
}

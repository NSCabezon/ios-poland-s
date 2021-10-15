//
//  SelectableAccountViewModel.swift
//  BLIK
//
//  Created by Piotr Mielcarzewicz on 29/07/2021.
//

import PLCommons

public struct SelectableAccountViewModel {
    public let name: String
    public let accountNumber: String
    public let accountNumberUnformatted: String
    public let availableFunds: String
    public let type: AccountForDebit.AccountType
    public let accountSequenceNumber: Int
    public let accountType: Int
    public var isSelected: Bool
    
    public init(name: String,
                accountNumber: String,
                accountNumberUnformatted: String,
                availableFunds: String,
                type: AccountForDebit.AccountType,
                accountSequenceNumber: Int,
                accountType: Int,
                isSelected: Bool) {
        self.name = name
        self.accountNumber = accountNumber
        self.accountNumberUnformatted = accountNumberUnformatted
        self.availableFunds = availableFunds
        self.type = type
        self.accountSequenceNumber = accountSequenceNumber
        self.accountType = accountType
        self.isSelected = isSelected
    }
}

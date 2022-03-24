//
//  TaxAccount.swift
//  TaxTransfer
//
//  Created by 185167 on 16/03/2022.
//

import PLScenes

struct TaxAccount: Equatable {
    let accountNumber: String
    let address: Address
    let accountName: String
    let taxFormType: Int
    let validFromDate: Date
    let validToDate: Date
    let isActive: Bool
    
    struct Address: Equatable {
        let street: String
        let city: String
        let zipCode: String
    }
}

extension TaxAccount: SelectableItem {
    var name: String {
        return accountName
    }
    
    var identifier: String {
        return accountName + " | " + accountNumber
    }
}

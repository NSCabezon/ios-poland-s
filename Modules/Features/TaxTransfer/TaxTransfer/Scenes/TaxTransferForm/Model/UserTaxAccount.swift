//
//  UserTaxAccount.swift
//  TaxTransfer
//
//  Created by 185167 on 12/04/2022.
//

import PLCommons

struct UserTaxAccount: Equatable {
    let accountNumber: String
    let id: String
    let systemId: Int
    let taxAccountId: String
    let currencyCode: String
    let accountName: AccountName
    let accountType: AccountType
    let balance: Money?
    let availableFunds: Money?
    let lastUpdate: Date
    
    struct AccountName: Equatable {
        let source: String
        let description: String
        let userDefined: String
    }
    
    enum AccountType: String, Equatable {
        case AVISTA, SAVINGS, DEPOSIT, CREDIT_CARD, LOAN, INVESTMENT, VAT, SLINK, EFX, OTHER, PERSONAL
    }
}

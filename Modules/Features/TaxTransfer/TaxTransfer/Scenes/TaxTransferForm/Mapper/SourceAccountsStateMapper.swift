//
//  SourceAccountsStateMapper.swift
//  TaxTransfer
//
//  Created by 185167 on 26/01/2022.
//

import PLCommons

protocol SourceAccountsStateMapping {
    func map(_ accounts: [AccountForDebit]) -> SourceAccountsState
}

final class SourceAccountsStateMapper: SourceAccountsStateMapping {
    func map(_ accounts: [AccountForDebit]) -> SourceAccountsState {
        if accounts.isEmpty {
            return .listIsEmpty
        }
        
        if let defualtAccount = accounts.first(where: { $0.defaultForPayments }) {
            return .listContainsDefaultAccount(defualtAccount)
        }
        
        if (accounts.count == 1), let onlyAccount = accounts.first, !onlyAccount.defaultForPayments {
            return .listContainsSingleNonDefaultAccount(onlyAccount)
        }
        
        return .listContainsMultipleNonDefaultAccounts(accounts)
    }
}

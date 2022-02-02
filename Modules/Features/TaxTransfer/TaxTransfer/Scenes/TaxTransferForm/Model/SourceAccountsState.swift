//
//  SourceAccountsState.swift
//  TaxTransfer
//
//  Created by 185167 on 26/01/2022.
//

import PLCommons

enum SourceAccountsState: Equatable {
    case listIsEmpty
    case listContainsDefaultAccount(AccountForDebit)
    case listContainsSingleNonDefaultAccount(AccountForDebit)
    case listContainsMultipleNonDefaultAccounts([AccountForDebit])
}

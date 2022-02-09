//
//  PLAccountTransaction.swift
//  Santander
//
//  Created by Rodrigo Jurado on 26/8/21.
//

import Account
import CoreFoundationLib

final class PLAccountTransaction: AccountTransactionProtocol {    
    func getError() -> String {
        return localized("transaction_label_emptyError")
    }

    let defaultNumberOfDateSearchFilter: Int = -89

    let isEnabledConceptFilter: Bool = true

    let isEnabledOperationTypeFilter: Bool = false

    let isEnabledAmountRangeFilter: Bool = true

    let isEnabledDateFilter: Bool = true

    let disabledEasyPayAccount: Bool = true
}

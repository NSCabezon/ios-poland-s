//
//  PLCardTransactionsSearchModifier.swift
//  Santander
//
//  Created by Fernando Sánchez García on 1/9/21.
//

import CoreFoundationLib
import Cards
import UI

final class PLCardTransactionsSearchModifier {
    init() {}
}

extension PLCardTransactionsSearchModifier: CardTransactionsSearchModifierProtocol {
    var isSearchLimitedBySCA: Bool {
        return false
    }
    var isTransactionNameFilterEnabled: Bool {
        return true
    }
    
    var isIncomeExpensesFilterEnabled: Bool {
        return true
    }
    
    var isAmountsRangeFilterEnabled: Bool {
        return true
    }
    
    var isOperationTypeFilterEnabled: Bool {
        return false
    }
}

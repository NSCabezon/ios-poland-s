//
//  PLCardTransactionsSearchModifier.swift
//  Santander
//
//  Created by Fernando Sánchez García on 1/9/21.
//

import Cards
import CoreFoundationLib
import UI
import SANPLLibrary

final class PLCardTransactionsSearchModifier {
    private let managersProvider: PLManagersProviderProtocol
    private let dependenciesEngine: DependenciesResolver & DependenciesInjector

    init(dependenciesEngine: DependenciesResolver & DependenciesInjector) {
        self.managersProvider = dependenciesEngine.resolve(for: PLManagersProviderProtocol.self)
        self.dependenciesEngine = dependenciesEngine
    }
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

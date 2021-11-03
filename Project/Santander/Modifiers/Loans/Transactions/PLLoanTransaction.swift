//
//  PLLoanTransaction.swift
//  Santander
//
//  Created by Rodrigo Jurado on 5/10/21.
//

import Loans
import Commons

final class PLLoanTransaction: LoanTransactionModifier {
    let isFiltersEnabled: Bool = true
    let isEnabledConceptFilter: Bool = false
    let isEnabledOperationTypeFilter: Bool = false
    let isEnabledAmountRangeFilter: Bool = true
    let isEnabledDateFilter: Bool = true
}

//
//  LoansModifier.swift
//  Santander
//
//  Created by Juan Carlos López Robles on 1/2/22.
//
import Loans
import Foundation

struct LoansModifier: LoansModifierProtocol {
    var waitForLoanDetail: Bool = true
    var hideFilterButton: Bool = false
    var transactionSortOrder: LoanTransactionsSortOrder = .mostRecent
}

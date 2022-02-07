//
//  PLLoanModifier.swift
//  Santander
//
//  Created by Francisco Perez Martinez on 20/7/21.
//

import Loans
import UI
import CoreFoundationLib
import SANPLLibrary
import LoanSchedule
import Account

final class PLLoanModifier {
    var hideFilterButton: Bool = false
    var waitForLoanDetail: Bool = false
    var transactionSortOrder: LoanTransactionsSortOrder = .mostRecent

    init() {}
}

extension PLLoanModifier: LoansModifierProtocol { }

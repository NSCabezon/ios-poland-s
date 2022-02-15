//
//  LoanTransactionActionsModifier.swift
//  Loans
//

import CoreFoundationLib

public protocol LoanTransactionActionsModifier {
    func didSelectAction(_ action: LoanActionType, forTransaction transaction: LoanTransactionEntity, andLoan loan: LoanEntity) -> Bool
}

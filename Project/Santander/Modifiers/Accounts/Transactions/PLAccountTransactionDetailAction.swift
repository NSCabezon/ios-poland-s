//
//  PLAccountTransactionDetailAction.swift
//  Santander
//

import Account
import CoreFoundationLib

class PLAccountTransactionDetailAction: AccountTransactionDetailActionProtocol {
    func getTransactionActions(for transaction: AccountTransactionEntity) -> [AccountTransactionDetailAction]? {
        return [.pdf, .share(nil)]
    }

    func showComingSoonToast() -> Bool {
        return true
    }
}

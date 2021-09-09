//
//  PLAccountTransactionDetailAction.swift
//  Santander
//

import Account
import Models

class PLAccountTransactionDetailAction: AccountTransactionDetailActionProtocol {
    func getTransactionActions(for transaction: AccountTransactionEntity) -> [AccountTransactionDetailAction]? {
        return [.share(nil), .pdf]
    }

    func showComingSoonToast() -> Bool {
        return true
    }
}

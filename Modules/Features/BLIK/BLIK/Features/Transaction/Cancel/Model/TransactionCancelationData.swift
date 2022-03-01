//
//  TransactionCancelationData.swift
//  BLIK
//
//  Created by 185167 on 24/02/2022.
//

struct TransactionCancelationData {
    let cancelType: CancelType
    let aliasContext: AliasContext
    
    enum CancelType: String {
        case timeout = "pl_blik_alert_timeOut"
        case exit = "pl_blik_alert_cancTransac"
    }

    enum AliasContext {
        case transactionPerformedWithoutAlias
        case transactionPerformedWithAlias(Transaction.Alias)
    }
}

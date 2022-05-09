//
//  PLFundsTransactionsFilterModifier.swift
//  Santander
//

import Funds
import CoreFoundationLib

final class PLFundsTransactionsFilterModifier: FundsTransactionsFilterModifier {
    var minFilterDate: Date {
        let polandMinDate = "1998-04-01"
        return polandMinDate.toDate(dateFormat: TimeFormat.yyyyMMdd.rawValue)
    }
}

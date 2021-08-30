//
//  TransferFilterInputAdapter.swift
//  PLLegacyAdapter
//
//  Created by Rodrigo Jurado on 2/8/21.
//

import Foundation
import SANLegacyLibrary
import SANPLLibrary

final class TransferFilterInputAdapter {
    static func adaptToPLFilter(accountNumber: String, filter: AccountTransferFilterInput) -> AccountTransactionsParameters {
        let movementType = self.adaptToPLMovement(movement: filter.movementType)
        let fromDate = filter.dateFilter.fromDateModel?.date.toString(format: "yyyy-MM-dd")
        let toDate = filter.dateFilter.toDateModel?.date.toString(format: "yyyy-MM-dd")
        let filters = AccountTransactionsParameters(accountNumbers: [accountNumber],
                                                    from: fromDate,
                                                    to: toDate,
                                                    state: nil,
                                                    text: nil,
                                                    postedFrom: nil,
                                                    postedTo: nil,
                                                    amountFrom: filter.startAmountDTO?.value,
                                                    amountTo: filter.endAmountDTO?.value,
                                                    sortOrder: "DESCENDING",
                                                    debitFlag: movementType,
                                                    pagingFirst: nil,
                                                    pagingLast: nil
        )
        return filters
    }

    static func adaptToPLMovement(movement: MovementType) -> String? {
        switch movement {
        case .expenses:
            return "DEBIT"
        case .income:
            return "CREDIT"
        default:
            return nil
        }
    }
}

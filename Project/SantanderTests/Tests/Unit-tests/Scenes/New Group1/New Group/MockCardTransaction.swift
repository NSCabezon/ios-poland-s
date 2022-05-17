//
//  MockCardTransaction.swift
//  SantanderTests
//
//  Created by Hernán Villamil on 12/5/22.
//

import Foundation
import CoreDomain

struct MockCardTransaction: CardTransactionRepresentable {
    var identifier: String?
    var transactionDate: Date?
    var operationDate: Date?
    var description: String?
    var amountRepresentable: AmountRepresentable?
    var annotationDate: Date?
    var transactionDay: String?
    var balanceCode: String?
    var sourceDate: String?
    var postedDate: String?
    var recipient: String?
    var cardAccountNumber: String?
    var operationType: String?
    var stateTitle: String?
    var receiptId: String?
}

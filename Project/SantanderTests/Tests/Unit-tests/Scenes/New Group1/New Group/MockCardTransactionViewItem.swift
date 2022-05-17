//
//  MockCardTransactionViewItem.swift
//  SantanderTests
//
//  Created by Hernán Villamil on 12/5/22.
//

import Foundation
import CoreDomain

struct MockCardTransactionViewItem {
    let card: CardRepresentable
    let transaction: CardTransactionRepresentable
    var showAmountBackground: Bool
    var cardDetail: CardDetailRepresentable?
    var transactionDetail: CardTransactionDetailRepresentable?
    var configuration: CardTransactionDetailConfigRepresentable?
    var contract: EasyPayContractTransactionRepresentable?
    var feeData: FeeDataRepresentable?
    var easyPay: EasyPayRepresentable?
    var isFractioned: Bool = false
    var minEasyPayAmount: Double?
    var viewConfiguration: [CardTransactionDetailViewConfigurationRepresentable]?
    var error: String?
    var offerRepresentable: OfferRepresentable?
    var shouldPresentFractionatedButton: Bool?
    
    init(card: CardRepresentable,
         transaction: CardTransactionRepresentable,
         showAmountBackground: Bool) {
        self.card = card
        self.transaction = transaction
        self.showAmountBackground = showAmountBackground
        self.configuration = MockCardTransactionDetailConfig()
    }
}

extension MockCardTransactionViewItem: CardTransactionViewItemRepresentable {
    var viewConfigurationRepresentable: [CardTransactionDetailViewConfigurationRepresentable] {
        get {
            viewConfiguration ?? []
        }
        set(newValue) {
            viewConfiguration = newValue
        }
    }
}

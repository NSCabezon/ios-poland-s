//
//  MockCardTransactionDetailConfig.swift
//  SantanderTests
//
//  Created by Hernán Villamil on 12/5/22.
//

import Foundation
import CoreDomain

struct MockCardTransactionDetailConfig: CardTransactionDetailConfigRepresentable {
    var isEnabledMap: Bool = true
    var isSplitExpensesEnabled: Bool = true
    var enableEasyPayCards: Bool = true
    var isEasyPayClassicEnabled: Bool = true
}

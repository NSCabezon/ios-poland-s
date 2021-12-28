//
//  PLCardTransactionDetailActionFactoryModifierProtocol.swift
//  Santander
//
//  Created by Alvaro Royo on 24/9/21.
//

import Foundation
import Cards
import CoreFoundationLib

class PLCardTransactionDetailActionFactoryModifier: CardTransactionDetailActionFactoryModifierProtocol {
    var addPDFDetail: Bool = true
    
    func customViewType() -> ActionButtonFillViewType {
        .none
    }

    func getCustomActions(for card: CardEntity) -> [CardActionType]? {
        return [.pdfDetail, .share(nil)]
    }
}

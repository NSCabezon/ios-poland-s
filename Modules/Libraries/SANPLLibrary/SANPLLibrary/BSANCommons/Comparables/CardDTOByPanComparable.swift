//
//  CardDTOByPanComparable.swift
//  SANPLLibrary
//

import Foundation
import SANLegacyLibrary

public protocol CardDTOByPanComparable {
    var panIdentifier: String? { get }
    
    func isEqualTo(_ card: CardDTOByPanComparable) -> Bool
}

public extension CardDTOByPanComparable {
    func isEqualTo(_ card: CardDTOByPanComparable) -> Bool {
        if self.panIdentifier == nil || card.panIdentifier == nil {
            return false
        } else {
            return self.panIdentifier == card.panIdentifier
        }
    }
}

extension SANLegacyLibrary.CardDTO: CardDTOByPanComparable {
    public var panIdentifier: String? {
        self.contract?.contractNumber
    }
}

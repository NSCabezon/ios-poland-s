//
//  AmountDTO.swift
//  SANPTLibrary
//
//  Created by Juan Carlos López Robles on 12/23/21.
//

import Foundation
import CoreDomain

struct AmountDTO {
    var value: Decimal?
    var currencyRepresentable: CurrencyRepresentable?
}

extension AmountDTO: AmountRepresentable {}

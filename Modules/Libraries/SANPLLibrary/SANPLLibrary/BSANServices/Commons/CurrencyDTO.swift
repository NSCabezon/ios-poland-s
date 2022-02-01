//
//  CurrencyDTO.swift
//  SANPTLibrary
//
//  Created by Juan Carlos López Robles on 12/23/21.
//

import Foundation
import CoreDomain

struct CurrencyDTO {
    var currencyName: String
    var currencyType: CurrencyType
    
    func getSymbol() -> String {
        return currencyType.symbol ?? currencyName
    }
}

extension CurrencyDTO: CurrencyRepresentable {}

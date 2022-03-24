//
//  TaxSymbol.swift
//  TaxTransfer
//
//  Created by 185167 on 15/03/2022.
//

import PLScenes

public struct TaxSymbol {
    public let symbolName: String
    public let symbolType: Int
    public let isActive: Bool
    public let isTimePeriodRequired: Bool
    public let isFundedFromVatAccount: Bool
    public let destinationAccountType: TaxAccountType
}

extension TaxSymbol: SelectableItem {
    public var name: String {
        return symbolName
    }
    
    public var identifier: String {
        return symbolName + " | \(symbolType)"
    }
}

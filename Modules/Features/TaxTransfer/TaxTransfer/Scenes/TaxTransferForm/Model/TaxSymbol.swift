//
//  TaxSymbol.swift
//  TaxTransfer
//
//  Created by 185167 on 15/03/2022.
//

struct TaxSymbol {
    let symbolName: String
    let symbolType: Int
    let isActive: Bool
    let isTimePeriodRequired: Bool
    let isFundedFromVatAccount: Bool
    let destinationAccountType: TaxAccountType
}

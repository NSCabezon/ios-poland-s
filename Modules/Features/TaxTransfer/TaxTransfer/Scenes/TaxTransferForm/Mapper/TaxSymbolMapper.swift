//
//  TaxSymbolMapper.swift
//  TaxTransfer
//
//  Created by 185167 on 15/03/2022.
//

import SANPLLibrary

protocol TaxSymbolMapping {
    func map(_ taxSymbol: TaxSymbolDTO) -> TaxSymbol
}

final class TaxSymbolMapper: TaxSymbolMapping {
    func map(_ taxSymbol: TaxSymbolDTO) -> TaxSymbol {
        let irpTaxSymbolType = 13
        let destinationAccountType: TaxAccountType = taxSymbol.type == irpTaxSymbolType ? .IRP : .US
        
        return TaxSymbol(
            symbolName: taxSymbol.symbol,
            symbolType: taxSymbol.type,
            isActive: taxSymbol.active,
            isTimePeriodRequired: taxSymbol.isTimePeriodRequired,
            isFundedFromVatAccount: taxSymbol.isFundedFromVatAccount,
            destinationAccountType: destinationAccountType
        )
    }
}

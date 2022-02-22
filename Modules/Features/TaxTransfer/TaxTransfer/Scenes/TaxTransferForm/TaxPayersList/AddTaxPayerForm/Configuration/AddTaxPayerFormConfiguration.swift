//
//  AddTaxPayerFormConfiguration.swift
//  TaxTransfer
//
//  Created by 187831 on 03/02/2022.
//

struct AddTaxPayerFormConfiguration {
    let info: String
    let charactersLimit: Int?
    
    var charactersLimitInfo: String {
        guard let limit = charactersLimit else { return "" }
        return "#Maksymalnie \(limit) znaków"
    }
}

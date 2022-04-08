//
//  AddTaxAuthorityFormViewModel.swift
//  TaxTransfer
//
//  Created by 185167 on 02/03/2022.
//

enum AddTaxAuthorityViewModel {
    case taxSymbolSelector
    case usForm(UsTaxAuthorityFormViewModel)
    case irpForm(IrpTaxAuthorityFormViewModel)
    
    struct UsTaxAuthorityFormViewModel {
        let taxSymbol: String
        var city: Selectable<CityName>
        var taxAuthority: Selectable<TaxAuthorityViewModel>
        
        typealias CityName = String
        struct TaxAuthorityViewModel {
            let taxAuthorityName: String
            let accountNumber: String
        }
    }
    
    struct IrpTaxAuthorityFormViewModel {
        let taxSymbol: String
        var taxAuthorityName: String?
        var accountNumber: String?
    }
}

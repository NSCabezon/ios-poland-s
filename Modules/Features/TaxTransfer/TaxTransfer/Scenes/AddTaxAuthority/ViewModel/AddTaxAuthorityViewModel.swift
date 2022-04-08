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
    
    var shouldEnableDoneButton: Bool {
        switch self {
        case .taxSymbolSelector:
            return false
        case let .irpForm(form):
            guard
                let authorityName = form.taxAuthorityName,
                let accountNumber = form.accountNumber,
                authorityName.isNotEmpty,
                accountNumber.isNotEmpty
            else {
                return false
            }
            return true
        case let .usForm(form):
            switch (form.city, form.taxAuthority) {
            case (.selected(_), .selected(_)):
                return true
            case (.selected(_), .unselected),
                 (.unselected, .selected(_)),
                 (.unselected, .unselected):
                return false
            }
        }
    }
}

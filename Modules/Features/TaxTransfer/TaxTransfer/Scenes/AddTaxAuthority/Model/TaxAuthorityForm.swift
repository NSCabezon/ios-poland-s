//
//  TaxAuthorityForm.swift
//  TaxTransfer
//
//  Created by 185167 on 02/03/2022.
//

enum TaxAuthorityForm {
    case formTypeUnselected
    case us(UsTaxAuthorityForm)
    case irp(IrpTaxAuthorityForm)
    
    var selectedTaxSymbol: TaxSymbol? {
        switch self {
        case .formTypeUnselected:
            return nil
        case let .irp(form):
            return form.taxSymbol
        case let .us(form):
            return form.taxSymbol
        }
    }
    
    var selectedCity: TaxAuthorityCity? {
        switch self {
        case .formTypeUnselected, .irp:
            return nil
        case let .us(form):
            guard let cityName = form.city else { return nil }
            return TaxAuthorityCity(cityName: cityName)
        }
    }
    
    var selectedTaxAccount: TaxAccount? {
        switch self {
        case .formTypeUnselected, .irp:
            return nil
        case let .us(form):
            return form.taxAuthorityAccount
        }
    }
}

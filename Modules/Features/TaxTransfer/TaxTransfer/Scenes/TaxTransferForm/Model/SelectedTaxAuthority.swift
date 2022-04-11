//
//  SelectedTaxAuthority.swift
//  TaxTransfer
//
//  Created by 185167 on 06/04/2022.
//

public enum SelectedTaxAuthority {
    case predefinedTaxAuthority(SelectedPredefinedTaxAuthorityData)
    case irpTaxAuthority(SelectedIrpTaxAuthorityData)
    case usTaxAuthority(SelectedUsTaxAuthorityData)
        
    public struct SelectedPredefinedTaxAuthorityData {
        let taxAuthority: TaxAuthority
        let taxSymbol: TaxSymbol
    }
    
    public struct SelectedIrpTaxAuthorityData {
        let taxSymbol: TaxSymbol
        let taxAuthorityName: String
        let accountNumber: String
    }
    
    public struct SelectedUsTaxAuthorityData {
        let taxSymbol: TaxSymbol
        let cityName: String
        let taxAuthorityAccount: TaxAccount
    }
    
    var selectedTaxSymbol: TaxSymbol {
        switch self {
        case let .predefinedTaxAuthority(selectedData):
            return selectedData.taxSymbol
        case let .irpTaxAuthority(selectedData):
            return selectedData.taxSymbol
        case let .usTaxAuthority(selectedData):
            return selectedData.taxSymbol
        }
    }
    
    var selectedPredefinedTaxAuthority: TaxAuthority? {
        switch self {
        case let .predefinedTaxAuthority(selectedData):
            return selectedData.taxAuthority
        case .usTaxAuthority, .irpTaxAuthority:
            return nil
        }
    }
}

//
//  SelectableTaxAuthorityViewModelMapper.swift
//  TaxTransfer
//
//  Created by 185167 on 10/03/2022.
//

protocol SelectableTaxAuthorityViewModelMapping {
    func map(_ taxAuthority: TaxAuthority, selectedTaxAuthority: TaxAuthority?) -> SelectableTaxAuthorityViewModel
}

final class SelectableTaxAuthorityViewModelMapper: SelectableTaxAuthorityViewModelMapping {
    func map(_ taxAuthority: TaxAuthority, selectedTaxAuthority: TaxAuthority?) -> SelectableTaxAuthorityViewModel {
        return SelectableTaxAuthorityViewModel(
            name: taxAuthority.name,
            location: getLocationText(of: taxAuthority),
            accountNumber: taxAuthority.accountNumber,
            isSelected: taxAuthority == selectedTaxAuthority,
            taxAuthority: taxAuthority
        )
    }
    
    private func getLocationText(of taxAuthority: TaxAuthority) -> String? {
        if case .IRP = taxAuthority.taxAccountType {
            return "#Centrum rozliczeniowe"
        }
        
        return taxAuthority.address
    }
}

//
//  SelectedTaxAuthorityMapper.swift
//  TaxTransfer
//
//  Created by 185167 on 06/04/2022.
//

protocol SelectedTaxAuthorityMapping {
    func map(_ form: TaxAuthorityForm) throws -> SelectedTaxAuthority
}

final class SelectedTaxAuthorityMapper: SelectedTaxAuthorityMapping {
    enum Error: Swift.Error {
        case formNotFullyFilled
    }
    
    func map(_ form: TaxAuthorityForm) throws -> SelectedTaxAuthority {
        switch form {
        case .formTypeUnselected:
            throw Error.formNotFullyFilled
        case let .us(form):
            guard
                let cityName = form.city,
                let taxAuthorityAccount = form.taxAuthorityAccount,
                cityName.isNotEmpty
            else {
                throw Error.formNotFullyFilled
            }
            let selectedData = SelectedTaxAuthority.SelectedUsTaxAuthorityData(
                taxSymbol: form.taxSymbol,
                cityName: cityName,
                taxAuthorityAccount: taxAuthorityAccount
            )
            return .usTaxAuthority(selectedData)
        case let .irp(form):
            guard
                let taxAuthorityName = form.taxAuthorityName,
                let accountNumber = form.accountNumber?.filter { !$0.isWhitespace },
                taxAuthorityName.isNotEmpty,
                accountNumber.isNotEmpty
            else {
                throw Error.formNotFullyFilled
            }
            let selectedData = SelectedTaxAuthority.SelectedIrpTaxAuthorityData(
                taxSymbol: form.taxSymbol,
                taxAuthorityName: taxAuthorityName,
                accountNumber: accountNumber
            )
            return .irpTaxAuthority(selectedData)
        }
    }
}

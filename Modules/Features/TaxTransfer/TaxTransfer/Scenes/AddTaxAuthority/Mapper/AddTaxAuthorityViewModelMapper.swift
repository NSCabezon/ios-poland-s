//
//  AddTaxAuthorityViewModelMapper.swift
//  TaxTransfer
//
//  Created by 185167 on 02/03/2022.
//

protocol AddTaxAuthorityViewModelMapping {
    func map(_ form: TaxAuthorityForm) -> AddTaxAuthorityViewModel
}

final class AddTaxAuthorityViewModelMapper: AddTaxAuthorityViewModelMapping {
    func map(_ form: TaxAuthorityForm) -> AddTaxAuthorityViewModel {
        switch form {
        case .formTypeUnselected:
            return .taxSymbolSelector
        case let .irp(form):
            return .irpForm(getIrpFormViewModel(from: form))
        case let .us(form):
            return .usForm(getUsFormViewModel(from: form))
        }
    }
}

private extension AddTaxAuthorityViewModelMapper {
    func getIrpFormViewModel(from form: IrpTaxAuthorityForm) -> AddTaxAuthorityViewModel.IrpTaxAuthorityFormViewModel {
        return .init(
            taxSymbol: form.taxSymbol.symbolName,
            taxAuthorityName: form.taxAuthorityName,
            accountNumber: form.accountNumber
        )
    }
    
    func getUsFormViewModel(from form: UsTaxAuthorityForm) -> AddTaxAuthorityViewModel.UsTaxAuthorityFormViewModel {
        return .init(
            taxSymbol: form.taxSymbol.symbolName,
            city: getCityViewModel(from: form.city),
            taxAuthority: getTaxAuthorityViewModel(from: form.taxAuthorityAccount)
        )
    }
    
    typealias CityViewModel = AddTaxAuthorityViewModel.UsTaxAuthorityFormViewModel.CityName
    func getCityViewModel(from cityName: String?) -> Selectable<CityViewModel> {
        if let cityName = cityName {
            return .selected(cityName)
        } else {
            return .unselected
        }
    }
    
    typealias TaxAuthorityViewModel = AddTaxAuthorityViewModel.UsTaxAuthorityFormViewModel.TaxAuthorityViewModel
    func getTaxAuthorityViewModel(from taxAccount: TaxAccount?) -> Selectable<TaxAuthorityViewModel> {
        if let taxAccount = taxAccount {
            return .selected(
                .init(
                    taxAuthorityName: taxAccount.accountName,
                    accountNumber: taxAccount.accountNumber
                )
            )
        } else {
            return .unselected
        }
    }
}

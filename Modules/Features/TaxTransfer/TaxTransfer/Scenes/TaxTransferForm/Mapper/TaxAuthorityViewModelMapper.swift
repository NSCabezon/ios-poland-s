//
//  TaxAuthorityViewModelMapper.swift
//  TaxTransfer
//
//  Created by 185167 on 06/04/2022.
//

import PLCommons

protocol TaxAuthorityViewModelMapping {
    func map(_ selectedTaxAuthority: SelectedTaxAuthority) -> TaxTransferFormViewModel.TaxAuthorityViewModel
}

final class TaxAuthorityViewModelMapper: TaxAuthorityViewModelMapping {
    func map(_ selectedTaxAuthority: SelectedTaxAuthority) -> TaxTransferFormViewModel.TaxAuthorityViewModel {
        switch selectedTaxAuthority {
        case let .predefinedTaxAuthority(taxAuthority):
            return getPredefinedTaxAuthorityViewModel(from: taxAuthority)
        case let .irpTaxAuthority(taxAuthority):
            return getIrpTaxAuthorityViewModel(from: taxAuthority)
        case let .usTaxAuthority(taxAuthority):
            return getUsTaxAuthorityViewModel(from: taxAuthority)
        }
    }
    
    private func getPredefinedTaxAuthorityViewModel(
        from selectedData: SelectedTaxAuthority.SelectedPredefinedTaxAuthorityData
    ) -> TaxTransferFormViewModel.TaxAuthorityViewModel {
        return TaxTransferFormViewModel.TaxAuthorityViewModel(
            taxAuthorityName: selectedData.taxAuthority.name,
            taxFormSymbol: selectedData.taxSymbol.name,
            destinationAccountNumber: IBANFormatter.format(iban: selectedData.taxAuthority.accountNumber)
        )
    }
    
    private func getIrpTaxAuthorityViewModel(
        from selectedData: SelectedTaxAuthority.SelectedIrpTaxAuthorityData
    ) -> TaxTransferFormViewModel.TaxAuthorityViewModel {
        return TaxTransferFormViewModel.TaxAuthorityViewModel(
            taxAuthorityName: selectedData.taxAuthorityName,
            taxFormSymbol: selectedData.taxSymbol.name,
            destinationAccountNumber: IBANFormatter.format(iban: selectedData.accountNumber)
        )
    }
    
    private func getUsTaxAuthorityViewModel(
        from selectedData: SelectedTaxAuthority.SelectedUsTaxAuthorityData
    ) -> TaxTransferFormViewModel.TaxAuthorityViewModel {
        return TaxTransferFormViewModel.TaxAuthorityViewModel(
            taxAuthorityName: selectedData.taxAuthorityAccount.name,
            taxFormSymbol: selectedData.taxSymbol.name,
            destinationAccountNumber: IBANFormatter.format(iban: selectedData.taxAuthorityAccount.accountNumber)
        )
    }
}

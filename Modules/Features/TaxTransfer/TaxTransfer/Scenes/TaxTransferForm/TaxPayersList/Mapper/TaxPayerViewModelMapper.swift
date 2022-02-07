//
//  TaxPayerViewModelMapper.swift
//  TaxTransfer
//
//  Created by 187831 on 19/01/2022.
//

protocol TaxPayerViewModelMapping {
    func map(_ payers: [TaxPayer]) -> [TaxTransferFormViewModel.TaxPayerViewModel]
    func map(_ taxPayer: TaxPayer) -> TaxTransferFormViewModel.TaxPayerViewModel
    func map(_ taxPayer: TaxPayer, selectedInfo: SelectedTaxPayerInfo) -> TaxTransferFormViewModel.TaxPayerViewModel
}

final class TaxPayerViewModelMapper: TaxPayerViewModelMapping {
    func map(_ taxPayer: TaxPayer) -> TaxTransferFormViewModel.TaxPayerViewModel {
        return map(taxPayer, selectedInfo: SelectedTaxPayerInfo(
                    taxIdentifier: "",
                    idType: .taxPayerIdentificationNumber
            )
        )
    }
    
    func map(_ taxPayer: [TaxPayer]) -> [TaxTransferFormViewModel.TaxPayerViewModel] {
        return taxPayer.map { taxPayer in
            map(taxPayer)
        }
    }
    
    func map(_ taxPayer: TaxPayer, selectedInfo: SelectedTaxPayerInfo) -> TaxTransferFormViewModel.TaxPayerViewModel {
        return TaxTransferFormViewModel.TaxPayerViewModel(
            taxPayer: taxPayer,
            taxPayerSecondaryIdentifier: taxPayer.secondaryTaxIdentifierNumber.isEmpty ?
                .notAvailable :
                .available(id: taxPayer.secondaryTaxIdentifierNumber),
            selectedInfo: selectedInfo
        )
    }
}

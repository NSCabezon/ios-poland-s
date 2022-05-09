//
//  TaxTransferPayerIdentifiersViewModel.swift
//  TaxTransfer
//
//  Created by 187831 on 17/01/2022.
//

import CoreFoundationLib

protocol TaxTransferPayerIdentifiersViewModelProtocol {
    var numberOfItems: Int { get }
    var numberOfSections: Int { get }
    var taxPayer: TaxPayer { get }
    var selectedInfo: SelectedTaxPayerInfo? { get }
    
    func set(taxPayer: TaxPayer)
    func selectIdenfier(index: Int)
    func identifier(for index: Int) -> String?
}

final class TaxTransferPayerIdentifiersViewModel {
    let numberOfItems = 2
    let numberOfSections = 1
    
    var taxPayer: TaxPayer
    
    var selectedInfo: SelectedTaxPayerInfo? {
        return getSelectedPayerInfo()
    }
    
    private var selectedIndex: Int?
    
    init(taxPayer: TaxPayer) {
        self.taxPayer = taxPayer
    }

    func identifier(for index: Int) -> String? {
        if index == 0, let taxIdentifier = taxPayer.taxIdentifier {
            return localized("pl_generic_docId_nip") + ": " + taxIdentifier
        } else {
            return taxPayer.idType.displayableValue + ": " + taxPayer.secondaryTaxIdentifierNumber
        }
    }
    
    func selectIdenfier(index: Int) {
        selectedIndex = index
    }
    
    func set(taxPayer: TaxPayer) {
        self.taxPayer = taxPayer
    }

    private func getSelectedPayerInfo() -> SelectedTaxPayerInfo {
        return SelectedTaxPayerInfo(
            taxIdentifier: selectedIndex == 0 ? (taxPayer.taxIdentifier ?? "") : taxPayer.secondaryTaxIdentifierNumber,
            idType: selectedIndex == 0 ? .taxPayerIdentificationNumber : taxPayer.idType
        )
    }
}

extension TaxTransferPayerIdentifiersViewModel: TaxTransferPayerIdentifiersViewModelProtocol { }

//
//  TaxTransferPayersListViewModel.swift
//  TaxTransfer
//
//  Created by 187831 on 24/12/2021.
//

import Foundation

protocol TaxTransferPayersListViewModelProtocol {
    var numberOfItems: Int { get }
    var numberOfSections: Int { get }
    var selectedInfo: SelectedTaxPayerInfo { get }
    var currentTaxPayer: TaxPayer? { get }
    
    func isSelected(index: Int) -> Bool
    func selectPayer(index: Int)
    func payer(for index: Int) -> TaxTransferFormViewModel.TaxPayerViewModel?
    func set(taxPayers: [TaxPayer])
    func set(selectedTaxPayer: TaxPayer)
}

final class TaxTransferPayersListViewModel: TaxTransferPayersListViewModelProtocol {
    let numberOfSections = 1
    
    var currentTaxPayer: TaxPayer? {
        return getCurrentTaxPayer()
    }
    
    var numberOfItems: Int {
        return taxPayers.count
    }
    
    var selectedInfo: SelectedTaxPayerInfo {
        return getSelectedInfo()
    }

    private lazy var taxPayers: [TaxTransferFormViewModel.TaxPayerViewModel] = []
    private var seletedPayerIndex: Int?
    private var selectedPayer: TaxPayer?
    private let mapper: TaxPayerViewModelMapping
    
    init(mapper: TaxPayerViewModelMapping) {
        self.mapper = mapper
    }
    
    func selectPayer(index: Int) {
        seletedPayerIndex = index
    }
    
    func payer(for index: Int) -> TaxTransferFormViewModel.TaxPayerViewModel? {
        return taxPayers[safe: index]
    }
    
    func isSelected(index: Int) -> Bool {
        let taxPayer = taxPayers[safe: index]?.taxPayer
        return currentTaxPayer == taxPayer
    }
    
    func set(taxPayers: [TaxPayer]) { // TODO: handle empty tax payers list: TAP-2105
        self.taxPayers = mapper.map(taxPayers)
    }
    
    func set(selectedTaxPayer: TaxPayer) {
        selectedPayer = selectedTaxPayer
    }
    
    private func getSelectedInfo() -> SelectedTaxPayerInfo {
        return SelectedTaxPayerInfo(
            taxIdentifier: currentTaxPayer?.taxIdentifier ?? currentTaxPayer?.secondaryTaxIdentifierNumber ?? "",
            idType: currentTaxPayer?.idType ?? .taxPayerIdentificationNumber
        )
    }
    
    private func getCurrentTaxPayer() -> TaxPayer? {
        if let seletedPayerIndex = seletedPayerIndex {
            return taxPayers[safe: seletedPayerIndex]?.taxPayer
        }
        
        if let currentTaxPayer = selectedPayer {
            return currentTaxPayer
        }

        return nil
    }
}

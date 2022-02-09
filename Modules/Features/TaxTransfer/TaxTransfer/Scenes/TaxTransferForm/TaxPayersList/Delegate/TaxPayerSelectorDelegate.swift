//
//  TaxPayerSelectorDelegate.swift
//  TaxTransfer
//
//  Created by 187831 on 01/02/2022.
//

protocol TaxPayerSelectorDelegate: AnyObject {
    func didSelectTaxPayer(_ taxPayer: TaxPayer, selectedPayerInfo: SelectedTaxPayerInfo)
}

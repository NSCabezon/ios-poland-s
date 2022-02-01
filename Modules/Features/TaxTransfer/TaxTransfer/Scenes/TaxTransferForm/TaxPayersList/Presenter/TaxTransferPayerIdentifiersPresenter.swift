//
//  TaxTransferPayerIdentifiersPresenter.swift
//  TaxTransfer
//
//  Created by 187831 on 17/01/2022.
//

import Commons

protocol TaxTransferPayerIdentifiersPresenterProtocol {
    var view: TaxTransferPayerIdentifiersViewController? { get set }
    
    func didPressBack()
    func didPressClose()
    func didSelectTaxPayerIdentifier(taxPayer: TaxPayer, selectedPayerInfo: SelectedTaxPayerInfo)
}

final class TaxTransferPayerIdentifiersPresenter {
    weak var view: TaxTransferPayerIdentifiersViewController?

    private var coordinator: TaxTransferFormCoordinatorProtocol {
        return dependenciesResolver.resolve()
    }
    
    private let dependenciesResolver: DependenciesResolver
    
    init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
    }
}

extension TaxTransferPayerIdentifiersPresenter: TaxTransferPayerIdentifiersPresenterProtocol {
    func didSelectTaxPayerIdentifier(taxPayer: TaxPayer, selectedPayerInfo: SelectedTaxPayerInfo) {
        coordinator.showTaxPayerSelector(taxPayer, selectedPayerInfo: selectedPayerInfo)
    }
    
    func didPressBack() {
        coordinator.backToForm()
    }
    
    func didPressClose() {
        coordinator.goToGlobalPosition()
    }
}

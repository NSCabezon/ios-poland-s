//
//  TaxTransferPayerIdentifiersPresenter.swift
//  TaxTransfer
//
//  Created by 187831 on 17/01/2022.
//

import CoreFoundationLib

protocol TaxTransferPayerIdentifiersPresenterProtocol {
    var view: TaxTransferPayerIdentifiersViewController? { get set }
    
    func didPressBack()
    func didPressClose()
    func didSelectTaxPayerIdentifier(taxPayer: TaxPayer, selectedPayerInfo: SelectedTaxPayerInfo)
}

final class TaxTransferPayerIdentifiersPresenter {
    weak var view: TaxTransferPayerIdentifiersViewController?
    
    private let dependenciesResolver: DependenciesResolver
    private let coordinator: TaxPayersListCoordinatorProtocol
    
    init(dependenciesResolver: DependenciesResolver,
         coordinator: TaxPayersListCoordinatorProtocol) {
        self.dependenciesResolver = dependenciesResolver
        self.coordinator = coordinator
    }
}

extension TaxTransferPayerIdentifiersPresenter: TaxTransferPayerIdentifiersPresenterProtocol {
    func didSelectTaxPayerIdentifier(taxPayer: TaxPayer, selectedPayerInfo: SelectedTaxPayerInfo) {
        coordinator.didSelectTaxPayer(taxPayer, selectedPayerInfo: selectedPayerInfo)
    }
    
    func didPressBack() {
        coordinator.backToForm()
    }
    
    func didPressClose() {
        coordinator.goToGlobalPosition()
    }
}

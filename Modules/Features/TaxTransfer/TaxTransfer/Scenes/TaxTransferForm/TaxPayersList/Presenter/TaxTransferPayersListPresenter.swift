//
//  TaxTransferPayersListPresenter.swift
//  TaxTransfer
//
//  Created by 187831 on 16/12/2021.
//

import CoreFoundationLib
import PLUI
import UI

protocol TaxTransferPayersListPresenterProtocol {
    var view: TaxTransferPayersListView? { get set }
    
    func didPressClose()
    func didPressBack()
    func didPressAddPayer()
    func didSelectTaxPayer(_ taxPayer: TaxPayer,
                           selectedPayerInfo: SelectedTaxPayerInfo)
}

final class TaxTransferPayersListPresenter {
    weak var view: TaxTransferPayersListView?
    
    private var confirmationDialogFactory: ConfirmationDialogProducing {
        return dependenciesResolver.resolve()
    }
    
    private var getTaxPayersUseCase: GetTaxPayersListUseCaseProtocol {
        return dependenciesResolver.resolve()
    }
    
    private var useCaseHandler: UseCaseHandler {
        return dependenciesResolver.resolve()
    }
    
    private var mapper: TaxPayerViewModelMapping {
        return dependenciesResolver.resolve()
    }
    
    private let dependenciesResolver: DependenciesResolver
    private let coordinator: TaxPayersListCoordinatorProtocol
    
    init(dependenciesResolver: DependenciesResolver,
         coordinator: TaxPayersListCoordinatorProtocol) {
        self.dependenciesResolver = dependenciesResolver
        self.coordinator = coordinator
    }
}

extension TaxTransferPayersListPresenter: TaxTransferPayersListPresenterProtocol {
    func didPressClose() {
        let closeConfirmationDialog = confirmationDialogFactory.create(
            message: localized("#Czy na pewno chcesz zakończyć"),
            confirmAction: { [weak self] in
                self?.coordinator.goToGlobalPosition()
            },
            declineAction: {}
        )
        view?.showDialog(closeConfirmationDialog)
    }
    
    func didPressBack() {
        coordinator.back()
    }
    
    func didSelectTaxPayer(_ taxPayer: TaxPayer, selectedPayerInfo: SelectedTaxPayerInfo) {
        let viewModel = mapper.map(taxPayer, selectedInfo: selectedPayerInfo)
        
        switch viewModel.taxPayerSecondaryIdentifier {
        case .available:
            if viewModel.hasDifferentTaxIdentifiers {
                coordinator.showPayerIdentifiers(for: taxPayer)
            } else {
                coordinator.didSelectTaxPayer(viewModel.taxPayer, selectedPayerInfo: selectedPayerInfo)
            }
        case .notAvailable:
            coordinator.didSelectTaxPayer(viewModel.taxPayer, selectedPayerInfo: selectedPayerInfo)
        }
    }
    
    func didPressAddPayer() {
        coordinator.showAddPayerView()
    }
}

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
    func viewDidLoad()
    func didSelectTaxPayer(_ taxPayer: TaxPayer,
                           selectedPayerInfo: SelectedTaxPayerInfo)
}

final class TaxTransferPayersListPresenter {
    weak var view: TaxTransferPayersListView?
    
    private var coordinator: TaxTransferFormCoordinatorProtocol {
        return dependenciesResolver.resolve()
    }
    
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
    
    init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
    }
}

extension TaxTransferPayersListPresenter: TaxTransferPayersListPresenterProtocol {
    func viewDidLoad() {
        view?.showLoader()

        Scenario(useCase: getTaxPayersUseCase)
            .execute(on: useCaseHandler)
            .onSuccess { [weak self] output in
                self?.view?.hideLoader(completion: {
                    self?.view?.set(taxPayers: output.taxPayers)
                })
            }
            .onError { [weak self] _ in
                self?.view?.hideLoader(completion: {
                    self?.view?.showServiceInaccessibleMessage { [weak self] in
                        self?.didPressBack()
                    }
                })
            }
    }
    
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
}

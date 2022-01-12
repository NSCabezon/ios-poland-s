//
//  TaxTransferFormPresenter.swift
//  TaxTransfer
//
//  Created by 185167 on 06/12/2021.
//

import Commons
import CoreFoundationLib
import PLCommons
import PLCommonOperatives

protocol TaxTransferFormPresenterProtocol {
    var view: TaxTransferFormView? { get set }
    func viewDidLoad()
    func getTaxFormConfiguration() -> TaxFormConfiguration
    func didTapBack()
    func didTapDone(with data: TaxTransferFormFieldsData)
    func didUpdateFields(with data: TaxTransferFormFieldsData)
}

final class TaxTransferFormPresenter {
    private let dependenciesResolver: DependenciesResolver
    private var fetchedAccounts: [AccountForDebit] = []
    weak var view: TaxTransferFormView?
    
    init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
    }
}

private extension TaxTransferFormPresenter {
    var coordinator: TaxTransferFormCoordinatorProtocol {
        dependenciesResolver.resolve()
    }
    var validator: TaxTransferFormValidating {
        dependenciesResolver.resolve()
    }
    var getAccountsUseCase: GetAccountsForDebitProtocol {
        dependenciesResolver.resolve()
    }
    var useCaseHandler: UseCaseHandler {
        return dependenciesResolver.resolve()
    }
}

extension TaxTransferFormPresenter: TaxTransferFormPresenterProtocol {
    func viewDidLoad() {
        view?.showLoader()
        Scenario(useCase: getAccountsUseCase)
            .execute(on: useCaseHandler)
            .onSuccess { [weak self] accounts in
                guard let strongSelf = self else { return }
                strongSelf.view?.hideLoader(completion: {
                    strongSelf.handleFetchedAccounts(accounts)
                })
            }
            .onError { [weak self] error in
                guard let strongSelf = self else { return }
                strongSelf.view?.hideLoader(completion: {
                    strongSelf.view?.showServiceInaccessibleMessage(onConfirm: { [weak self] in
                        self?.coordinator.back()
                    })
                })
            }
    }
    
    func getTaxFormConfiguration() -> TaxFormConfiguration {
        dependenciesResolver.resolve(for: TaxFormConfiguration.self)
    }
    
    func didTapBack() {
        coordinator.back()
    }
    
    func didTapDone(with data: TaxTransferFormFieldsData) {
        // TODO:- Implement tax transfer request
    }
    
    func didUpdateFields(with data: TaxTransferFormFieldsData) {
        let validationResult = validator.validateData(data)
        switch validationResult {
        case .valid:
            view?.enableDoneButton()
        case let .invalid(messages):
            view?.disableDoneButton(with: messages)
        }
    }
}

private extension TaxTransferFormPresenter {
    func handleFetchedAccounts(_ accounts: [AccountForDebit]) {
        fetchedAccounts = accounts
        
        guard !accounts.isEmpty else {
            // TODO:- Handle empty accounts list
            return
        }
        
        let potentialDefaultAccount = accounts.first { $0.defaultForPayments }
        if let defaultAccount = potentialDefaultAccount {
            // TODO:- Fill view with viewModel
        } else {
            // TODO:- Navigate to account selector
        }
    }
}

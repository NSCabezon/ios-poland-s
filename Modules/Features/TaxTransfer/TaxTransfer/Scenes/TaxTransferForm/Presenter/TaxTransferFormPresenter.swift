//
//  TaxTransferFormPresenter.swift
//  TaxTransfer
//
//  Created by 185167 on 06/12/2021.
//

import Commons

protocol TaxTransferFormPresenterProtocol {
    var view: TaxTransferFormView? { get set }
    func getTaxFormConfiguration() -> TaxFormConfiguration
    func didTapBack()
    func didTapDone(with data: TaxTransferFormFieldsData)
    func didUpdateFields(with data: TaxTransferFormFieldsData)
}

final class TaxTransferFormPresenter {
    private let dependenciesResolver: DependenciesResolver
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
}

extension TaxTransferFormPresenter: TaxTransferFormPresenterProtocol {
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
        let validationResult = validator.validateDataWithoutAmountLimits(data)
        switch validationResult {
        case .valid:
            view?.enableDoneButton()
        case let .invalid(messages):
            view?.disableDoneButton(with: messages)
        }
    }
}

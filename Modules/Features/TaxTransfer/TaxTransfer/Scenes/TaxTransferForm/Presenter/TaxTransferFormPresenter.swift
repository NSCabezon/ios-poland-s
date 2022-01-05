//
//  TaxTransferFormPresenter.swift
//  TaxTransfer
//
//  Created by 185167 on 06/12/2021.
//

import Commons

protocol TaxTransferFormPresenterProtocol {
    var view: TaxTransferFormView? { get set }
    func getDateSelectorConfiguration() -> DateSelectorConfiguration
    func didTapBack()
    func didTapDone()
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
}

extension TaxTransferFormPresenter: TaxTransferFormPresenterProtocol {
    func getDateSelectorConfiguration() -> DateSelectorConfiguration {
        dependenciesResolver.resolve(for: DateSelectorConfiguration.self)
    }
    
    func didTapBack() {
        coordinator.back()
    }
    
    func didTapDone() {
        // TODO:- Implement tax transfer request
    }
}

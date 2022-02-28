//
//  AddTaxAuthorityPresenter.swift
//  TaxTransfer
//
//  Created by 185167 on 15/02/2022.
//

import CoreFoundationLib

protocol AddTaxAuthorityPresenterProtocol {
    func viewDidLoad()
    func didTapBack()
    func didTapClose()
}

final class AddTaxAuthorityPresenter: AddTaxAuthorityPresenterProtocol {
    private let dependenciesResolver: DependenciesResolver
    
    init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
    }
    
    func viewDidLoad() {
        // TODO:- Configure view
    }
    
    func didTapBack() {
        coordinator.back()
    }
    
    func didTapClose() {
        coordinator.close()
    }
}

private extension AddTaxAuthorityPresenter {
    var coordinator: AddTaxAuthorityCoordinatorProtocol {
        dependenciesResolver.resolve()
    }
}

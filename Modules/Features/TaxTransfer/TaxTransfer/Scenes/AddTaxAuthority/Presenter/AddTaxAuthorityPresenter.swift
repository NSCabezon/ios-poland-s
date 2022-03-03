//
//  AddTaxAuthorityPresenter.swift
//  TaxTransfer
//
//  Created by 185167 on 15/02/2022.
//

import CoreFoundationLib

protocol AddTaxAuthorityPresenterProtocol {
    var view: AddTaxAuthorityView? { get set }
    func viewDidLoad()
    func didTapTaxSymbolSelector()
    func didTapCitySelector()
    func didTapTaxAuthoritySelector()
    func didTapBack()
    func didTapClose()
}

final class AddTaxAuthorityPresenter: AddTaxAuthorityPresenterProtocol {
    private let dependenciesResolver: DependenciesResolver
    private var form: TaxAuthorityForm
    weak var view: AddTaxAuthorityView?
    
    init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
        self.form = .formTypeUnselected
    }
    
    func viewDidLoad() {
        let viewModel = viewModelMapper.map(form)
        view?.setViewModel(viewModel)
    }
    
    func didTapTaxSymbolSelector() {
        // TODO:- Add tax symbol selector navigation
    }
    
    func didTapCitySelector() {
        // TODO:- Add city selector navigation
    }
    
    func didTapTaxAuthoritySelector() {
        // TODO:- Add tax authority selector navigation
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
    
    var viewModelMapper: AddTaxAuthorityViewModelMapping {
        dependenciesResolver.resolve()
    }
}

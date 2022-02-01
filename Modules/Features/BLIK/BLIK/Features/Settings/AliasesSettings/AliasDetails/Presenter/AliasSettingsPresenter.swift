//
//  AliasSettingsPresenter.swift
//  BLIK
//
//  Created by Piotr Mielcarzewicz on 03/09/2021.
//

import CoreFoundationLib

protocol AliasSettingsPresenterProtocol {
    var view: AliasSettingsView? { get set }
    func viewDidLoad()
    func didSelectOption(_ option: AliasSettingsOption)
    func didPressClose()
}

final class AliasSettingsPresenter: AliasSettingsPresenterProtocol {
    private let dependenciesResolver: DependenciesResolver
    private var coordinator: AliasSettingsCoordinatorProtocol {
        dependenciesResolver.resolve()
    }
    private var viewModelMapper: AliasSettingsViewModelMapping {
        dependenciesResolver.resolve()
    }
    private var alias: BlikAlias
    weak var view: AliasSettingsView?
    
    init(
        dependenciesResolver: DependenciesResolver,
        alias: BlikAlias
    ) {
        self.dependenciesResolver = dependenciesResolver
        self.alias = alias
    }
    
    func viewDidLoad() {
        let viewModel = viewModelMapper.map(alias)
        view?.setViewModel(viewModel)
    }
    
    func didSelectOption(_ option: AliasSettingsOption) {
        switch option {
        case .changeAliasName:
            coordinator.showAliasRenameScreen()
        case .setValidityPeriod:
            coordinator.showAliasChangeDateScreen()
        case .delete:
            coordinator.showAliasDeletionScreen()
        }
    }
    
    func didPressClose() {
        coordinator.goBack()
    }
}

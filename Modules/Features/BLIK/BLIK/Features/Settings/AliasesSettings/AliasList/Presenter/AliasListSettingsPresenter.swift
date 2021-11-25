//
//  AliasListSettingsPresenter.swift
//  BLIK
//
//  Created by Piotr Mielcarzewicz on 31/08/2021.
//

import CoreFoundationLib
import Commons
import PLUI

protocol AliasListSettingsPresenterProtocol {
    var view: AliasListSettingsView? { get set }
    func didPressClose()
    func didSelectAlias(_ alias: BlikAlias)
    func viewDidLoad()
    func didTriggerReload()
}

final class AliasListSettingsPresenter: AliasListSettingsPresenterProtocol {
    private let dependenciesResolver: DependenciesResolver
    private var coordinator: AliasListSettingsCoordinatorProtocol {
        dependenciesResolver.resolve()
    }
    private var getAliasesUseCase: GetAliasesUseCaseProtocol {
        dependenciesResolver.resolve()
    }
    private var viewModelMapper: AliasListSettingsViewModelMapping {
        dependenciesResolver.resolve()
    }
    private var useCaseHandler: UseCaseHandler {
        return self.dependenciesResolver.resolve(for: UseCaseHandler.self)
    }
    weak var view: AliasListSettingsView?
    
    init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
    }
    
    func didPressClose() {
        coordinator.goBack()
    }
    
    func didSelectAlias(_ alias: BlikAlias) {
        coordinator.showAliasSettings(for: alias)
    }
    
    func viewDidLoad() {
        loadAndDisplayFreshData()
    }
    
    func didTriggerReload() {
        loadAndDisplayFreshData()
    }
    
    private func loadAndDisplayFreshData() {
        view?.showLoader()
        Scenario(useCase: getAliasesUseCase)
            .execute(on: useCaseHandler)
            .onSuccess { [weak self] aliases in
                guard let strongSelf = self else { return }
                strongSelf.view?.hideLoader(completion: {
                    strongSelf.handleFetchedAliases(aliases)
                })
            }
            .onError { [weak self] error in
                guard let strongSelf = self else { return }
                strongSelf.view?.hideLoader(completion: {
                    strongSelf.view?.showServiceInaccessibleMessage(onConfirm: { [weak self] in
                        self?.coordinator.goBack()
                    })
                })
            }
    }
    
    private func handleFetchedAliases(_ aliases: [BlikAlias]) {
        let viewModels = viewModelMapper.map(aliases)
        view?.setViewModels(viewModels)
    }
}

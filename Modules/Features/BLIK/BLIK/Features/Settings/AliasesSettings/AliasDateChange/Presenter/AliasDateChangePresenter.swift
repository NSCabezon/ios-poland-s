//
//  AliasDateChangePresenter.swift
//  BLIK
//
//  Created by 186491 on 17/09/2021.
//

import CoreFoundationLib
import UI
import PLUI
import PLCommons

protocol AliasDateChangePresenterProtocol {
    var view: AliasDateChangeView? { get set }
    func viewDidLoad()
    func didPressClose()
    func didPressSave()
}

final class AliasDateChangePresenter: AliasDateChangePresenterProtocol {
    private let dependenciesResolver: DependenciesResolver
    private var updateAliasUseCase: UpdateAliasUseCaseProtocol {
        dependenciesResolver.resolve()
    }
    
    private var coordinator: AliasDateChangeCoordinatorProtocol {
        dependenciesResolver.resolve()
    }
    
    private var blikAliasNewDateMapper: BlikAliasNewDateMapping {
        dependenciesResolver.resolve()
    }
    
    private var useCaseHandler: UseCaseHandler {
        return self.dependenciesResolver.resolve(for: UseCaseHandler.self)
    }
    
    private let alias: BlikAlias
    
    weak var view: AliasDateChangeView?
    
    init(
        dependenciesResolver: DependenciesResolver,
        alias: BlikAlias
    ) {
        self.dependenciesResolver = dependenciesResolver
        self.alias = alias
    }
    
    func viewDidLoad() {
        view?.set(.init())
    }
    
    func didPressClose() {
        coordinator.goBack()
    }
    
    func didPressSave() {
        guard let validityPeriod = view?.validityPeriod else {
            return
        }
        
        view?.showLoader()
        let updatedAlias = blikAliasNewDateMapper.map(alias: alias, validityPeriod: validityPeriod)
        Scenario(useCase: updateAliasUseCase, input: updatedAlias)
            .execute(on: useCaseHandler)
            .onSuccess { [weak self] in
                self?.view?.hideLoader(completion: {
                    self?.handleAliasUpdateSuccess()
                })
            }
            .onError { [weak self] error in
                self?.view?.hideLoader(completion: {
                    self?.view?.showServiceInaccessibleMessage(onConfirm: nil)
                })
            }
    }
}
    
private extension AliasDateChangePresenter {
    func handleAliasUpdateSuccess() {
        TopAlertController
            .setup(TopAlertView.self)
            .showAlert(
                localized("pl_blik_text_dateSetSuccess"),
                alertType: .info,
                position: .top
            )
        coordinator.goBackToAliasListAndRefreshIt()
    }
}

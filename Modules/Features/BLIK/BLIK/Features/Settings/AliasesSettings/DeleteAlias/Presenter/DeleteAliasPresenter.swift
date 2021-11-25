//
//  DeleteAliasPresenter.swift
//  BLIK
//
//  Created by Piotr Mielcarzewicz on 06/09/2021.
//

import Commons
import CoreFoundationLib
import UI
import PLUI

protocol DeleteAliasPresenterProtocol {
    func didPressDelete(deletionReason: DeleteAliasReason)
    func didPressClose()
}

final class DeleteAliasPresenter: DeleteAliasPresenterProtocol {
    private let alias: BlikAlias
    private let dependenciesResolver: DependenciesResolver
    private var coordinator: DeleteAliasCoordinatorProtocol {
        dependenciesResolver.resolve()
    }
    private var deleteAliasUseCase: DeleteAliasUseCaseProtocol {
        dependenciesResolver.resolve()
    }
    private var useCaseHandler: UseCaseHandler {
        return self.dependenciesResolver.resolve(for: UseCaseHandler.self)
    }
    weak var view: DeleteAliasView?
    
    init(
        alias: BlikAlias,
        dependenciesResolver: DependenciesResolver
    ) {
        self.alias = alias
        self.dependenciesResolver = dependenciesResolver
    }
    
    func didPressDelete(deletionReason: DeleteAliasReason) {
        let request = DeleteAliasRequest(
            alias: alias,
            deletionReason: deletionReason
        )
        view?.showLoader()
        Scenario(useCase: deleteAliasUseCase, input: request)
            .execute(on: useCaseHandler)
            .onSuccess { [weak self] in
                self?.view?.hideLoader(completion: {
                    self?.handleAliasDeletion()
                })
            }
            .onError { [weak self] error in
                self?.view?.hideLoader(completion: {
                    self?.view?.showServiceInaccessibleMessage(onConfirm: nil)
                })
            }
    }
    
    func didPressClose() {
        coordinator.goBack()
    }
    
    private func handleAliasDeletion() {
        TopAlertController
            .setup(TopAlertView.self)
            .showAlert(
                localized("pl_blik_text_deviceDeletedSuccess"),
                alertType: .info,
                position: .top
            )
        coordinator.goBackToAliasListAndRefreshIt()
    }
}

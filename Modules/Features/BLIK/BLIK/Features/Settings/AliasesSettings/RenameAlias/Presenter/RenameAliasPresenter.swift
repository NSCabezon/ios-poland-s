//
//  RenameAliasPresenter.swift
//  BLIK
//
//  Created by Piotr Mielcarzewicz on 13/09/2021.
//

import Commons
import DomainCommon
import UI
import PLUI

protocol RenameAliasPresenterProtocol {
    func viewDidLoad()
    func didPressSave(with label: String)
    func didPressClose(with label: String)
}

final class RenameAliasPresenter: RenameAliasPresenterProtocol {
    private let dependenciesResolver: DependenciesResolver
    private let alias: BlikAlias
    private var coordinator: RenameAliasCoordinatorProtocol {
        dependenciesResolver.resolve()
    }
    private var registerAliasUseCase: RegisterAliasUseCaseProtocol {
        dependenciesResolver.resolve()
    }
    private var blikAliasNewLabelMapper: BlikAliasNewLabelMapping {
        dependenciesResolver.resolve()
    }
    private var confirmationDialogFactory: ConfirmationDialogProducing {
        dependenciesResolver.resolve()
    }
    private var useCaseHandler: UseCaseHandler {
        return self.dependenciesResolver.resolve(for: UseCaseHandler.self)
    }
    weak var view: RenameAliasView?
    
    init(
        dependenciesResolver: DependenciesResolver,
        alias: BlikAlias
    ) {
        self.dependenciesResolver = dependenciesResolver
        self.alias = alias
    }
    
    func viewDidLoad() {
        view?.setAliasLabel(alias.label)
    }
    
    func didPressSave(with label: String) {
        view?.showLoader()
        let updatedAlias = blikAliasNewLabelMapper.map(alias: alias, withNewLabel: label)
        Scenario(useCase: registerAliasUseCase, input: updatedAlias)
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
    
    func didPressClose(with label: String) {
        let aliasLabelFieldDidNotChange = (label == alias.label)
        if aliasLabelFieldDidNotChange {
            coordinator.goBack()
            return
        }
        
        let closeConfirmationDialog = confirmationDialogFactory.create(
            message: localized("pl_blik_text_cancelAlert"),
            confirmAction: { [weak self] in
                self?.coordinator.goBack()
            },
            declineAction: {}
        )
        view?.showDialog(closeConfirmationDialog)
    }
    
    private func handleAliasUpdateSuccess() {
        TopAlertController
            .setup(TopAlertView.self)
            .showAlert(
                localized("pl_blik_text_nameChangedSuccess"),
                alertType: .info,
                position: .top
            )
        coordinator.goBackToAliasListAndRefreshIt()
    }
}

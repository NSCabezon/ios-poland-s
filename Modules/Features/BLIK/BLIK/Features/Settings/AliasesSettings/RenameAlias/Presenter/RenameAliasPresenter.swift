//
//  RenameAliasPresenter.swift
//  BLIK
//
//  Created by Piotr Mielcarzewicz on 13/09/2021.
//

import CoreFoundationLib
import CoreFoundationLib
import UI
import PLUI
import PLCommons

protocol RenameAliasPresenterProtocol {
    func viewDidLoad()
    func didPressSave(with label: String)
    func didPressClose(with label: String)
    func didUpdateNameAlias(name: String?)
}

final class RenameAliasPresenter: RenameAliasPresenterProtocol {
    private let dependenciesResolver: DependenciesResolver
    private let alias: BlikAlias
    private var coordinator: RenameAliasCoordinatorProtocol {
        dependenciesResolver.resolve()
    }
    private var updateAliasUseCase: UpdateAliasUseCaseProtocol {
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
    private var validator: AliasNameValidatorProtocol {
     dependenciesResolver.resolve(for: AliasNameValidatorProtocol.self)
    }
    weak var view: RenameAliasViewProtocol?
    
    init(
        dependenciesResolver: DependenciesResolver,
        alias: BlikAlias
    ) {
        self.dependenciesResolver = dependenciesResolver
        self.alias = alias
    }
    
    func viewDidLoad() {
        view?.setAliasLabel(alias.label)
        didUpdateNameAlias(name: alias.label)
    }
    
    func didUpdateNameAlias(name: String?) {
        let isNameValid = validator.validate(name)
        switch isNameValid {
        case .valid:
            view?.clearValidationMessages()
        case let .invalid(messages):
            view?.showInvalidFormMessages(messages)
        }
    }
    
    func didPressSave(with label: String) {
        view?.showLoader()
        let updatedAlias = blikAliasNewLabelMapper.map(alias: alias, withNewLabel: label)
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

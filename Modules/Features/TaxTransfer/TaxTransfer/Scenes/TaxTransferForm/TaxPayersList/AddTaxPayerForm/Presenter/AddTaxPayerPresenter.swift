//
//  AddTaxPayerFormPresenter.swift
//  TaxTransfer
//
//  Created by 187831 on 02/02/2022.
//

import Commons
import PLUI

protocol AddTaxPayerPresenterFormProtocol {
    func didPressBack()
    func didPressClose()
    func didTapDone()
}

final class AddTaxPayerFormPresenter {
    weak var view: AddTaxPayerFormView?
    
    private var confirmationDialogFactory: ConfirmationDialogProducing {
        return dependenciesResolver.resolve()
    }
    
    private let dependenciesResolver: DependenciesResolver
    private let coordinator: AddTaxPayerFormCoordinatorProtocol
    
    init(
        dependenciesResolver: DependenciesResolver,
        coordinator: AddTaxPayerFormCoordinatorProtocol
    ) {
        self.dependenciesResolver = dependenciesResolver
        self.coordinator = coordinator
    }
}

extension AddTaxPayerFormPresenter: AddTaxPayerPresenterFormProtocol {
    func didPressBack() {
        coordinator.back()
    }
    
    func didPressClose() {
        let closeConfirmationDialog = confirmationDialogFactory.create(
            message: localized("#Czy na pewno chcesz zakończyć"),
            confirmAction: { [weak self] in
                self?.coordinator.goToGlobalPosition()
            },
            declineAction: {}
        )
        view?.showDialog(closeConfirmationDialog)
    }
    
    func didTapDone() {
        // TODO: will be added in next PR
    }
}

extension AddTaxPayerFormPresenter: AddTaxPayerViewDelegate {
    func didEndEditing() {
        validate()
    }
}

private extension AddTaxPayerFormPresenter {
    func validate() {
        guard let form = view?.getForm() else { return }
        let validator = AddTaxPayerFormValidator(type: form.identifierType)
        
        switch validator.validate(form) {
        case .valid:
            view?.clearValidationMessages()
        case let .invalid(messages):
            view?.showInvalidFormMessages(messages)
        }
    }
}

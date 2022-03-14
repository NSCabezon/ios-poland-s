//
//  AddTaxPayerFormPresenter.swift
//  TaxTransfer
//
//  Created by 187831 on 02/02/2022.
//

import CoreFoundationLib
import PLUI
import PLScenes

protocol AddTaxPayerPresenterFormProtocol {
    func didPressBack()
    func didPressClose()
    func didTapDone()
    
    func handleSelectedTaxIdentifier(item: TaxIdentifierType)
}

final class AddTaxPayerFormPresenter {
    weak var view: AddTaxPayerFormView?
    
    private var selectedTaxIdentifier: TaxIdentifierType?
    
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
    func handleSelectedTaxIdentifier(item: TaxIdentifierType) {
        selectedTaxIdentifier = item
        view?.setUp(with: getSelectableIdentifierType())
    }
    
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
        guard let taxPayer = getTaxPayer() else { return }
        coordinator.didTapDone(with: taxPayer)
    }
}

extension AddTaxPayerFormPresenter: AddTaxPayerViewDelegate {
    func didTapIdentifiersSelector() {
        coordinator.showIdentifiersSelectorView(
            with: getItemSelectorConfiguration(),
            selectedItem: selectedTaxIdentifier
        )
    }
    
    func didEndEditing() {
        validate()
    }
}

private extension AddTaxPayerFormPresenter {
    var confirmationDialogFactory: ConfirmationDialogProducing {
        return dependenciesResolver.resolve()
    }
    
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
    
    func getItemSelectorConfiguration() -> ItemSelectorConfiguration<TaxIdentifierType>.ItemSelectorSection {
        return ItemSelectorConfiguration<TaxIdentifierType>.ItemSelectorSection(
            sectionTitle: "#Wybierz typ identyfikatora",
            items: [.NIP,
                    .PESEL,
                    .passport,
                    .ID,
                    .REGON,
                    .other]
        )
    }
    
    func getSelectableIdentifierType() -> Selectable<TaxIdentifierType> {
        guard let selectedTaxIdentifier = selectedTaxIdentifier else {
            return .unselected
        }
        
        return .selected(selectedTaxIdentifier)
    }
    
    func getTaxPayer() -> TaxPayer? {
        guard let form = view?.getForm() else { return nil }
        let mapper = dependenciesResolver.resolve(for: TaxIdentifierMapping.self)
        
        return TaxPayer(
            identifier: UUID().hashValue,
            shortName: "",
            name: form.payerName,
            taxIdentifier: nil,
            secondaryTaxIdentifierNumber: form.identifierNumber,
            idType: mapper.map(form.identifierType))
    }
}


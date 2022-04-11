//
//  TaxTransferBillingPeriodPresenter.swift
//  TaxTransfer
//
//  Created by 187831 on 03/03/2022.
//

import CoreFoundationLib
import PLUI
 
final class TaxTransferBillingPeriodPresenter {
    weak var view: TaxTransferFormBillingPeriodFormView?
    
    private let dependenciesResolver: DependenciesResolver
    private var selectedPeriodType: TaxTransferBillingPeriodType?
    private var selectedPeriodNumber: Int?
    
    init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
    }
    
    func handleSelectedItem(item: TaxTransferBillingPeriodType) {
        selectedPeriodType = item
        view?.setUp(with: getPeriodViewModel())
        validate()
    }
    
    func handleSelectedItem(item: Int) {
        selectedPeriodNumber = item
        view?.setUp(periodNumber: getSelectablePeriodNumber())
        validate()
    }
    
    func didTapDone() {
        guard let form = getForm() else { return }
        coordinator.didTapDone(with: form)
    }
    
    func didPressBack() {
        coordinator.didPressBack()
    }
    
    func didPressClose() {
        let closeConfirmationDialog = confirmationDialogFactory.create(
            message: localized("#Czy na pewno chcesz zakończyć"),
            confirmAction: { [weak self] in
                self?.coordinator.didPressClose()
            },
            declineAction: {}
        )
        view?.showDialog(closeConfirmationDialog)
    }
    
    func getForm() -> TaxTransferBillingPeriodForm? {
        return view?.getForm()
    }
}

extension TaxTransferBillingPeriodPresenter: TaxTransferFormBillingPeriodFormViewDelegate {
    func didTapPeriodType() {
        coordinator.showSelector(
            with: .init(
                sectionTitle: localized("pl_taxTransfer_text_choosePeriod"),
                items: [.year, .halfYear, .quarter, .month, .decade, .day]
            ),
            title: localized("pl_taxTransfer_text_periodType"),
            selectedItem: selectedPeriodType
        )
    }
    
    func didTapPeriodNumber() {
        guard let selectedPeriodType = selectedPeriodType else {
            return
        }
        coordinator.showSelector(
            with: .init(
                sectionTitle: localized("#Wybierz numer okresu:"),
                items: selectedPeriodType.periodNumbers),
            title: localized("#Numer okresu"),
            selectedItem: selectedPeriodNumber
        )
    }
    
    func didEndEditing() {
        validate()
    }
}

private extension TaxTransferBillingPeriodPresenter {
    var coordinator: TaxTransferBillingPeriodCoordinator {
        dependenciesResolver.resolve()
    }
    
    var confirmationDialogFactory: ConfirmationDialogProducing {
        return dependenciesResolver.resolve()
    }
    
    var mapper: TaxBillingPeriodViewModelMapping {
        dependenciesResolver.resolve()
    }
    
    var validator: TaxTransferBillingPeriodValidating {
        dependenciesResolver.resolve()
    }
    
    func getSelectablePeriodNumber() -> Selectable<Int> {
        guard let selectedPeriodNumber = selectedPeriodNumber else {
            return .unselected
        }
        
        return .selected(selectedPeriodNumber)
    }
    
    func getPeriodViewModel() -> Selectable<TaxTransferFormViewModel.TaxBillingPeriodViewModel> {
        guard let selectedPeriodType = selectedPeriodType else {
            return .unselected
        }
        let viewModel = mapper.map(
            selectedPeriodType,
            year: view?.getForm()?.year ?? "",
            periodNumber: selectedPeriodNumber
        )
        return .selected(viewModel)
    }
    
    func validate() {
        guard let form = view?.getForm() else {
            view?.disableBottomButton()
            return
        }
        let validate = validator.validate(form)
        
        switch validate {
        case .valid:
            view?.clearValidationMessages()
        case let .invalid(messages):
            view?.showInvalidFormMessages(messages)
        }
    }
}

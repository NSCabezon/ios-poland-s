//
//  OtherBlikSettingsPresenter.swift
//  BLIK
//
//  Created by 186491 on 06/08/2021.
//

import UI
import Commons
import PLCommons
import PLUI

protocol OtherBlikSettingsPresenterProtocol {
    func viewDidLoad()
    func didPressSave(viewModel: OtherBlikSettingsViewModel)
    func didPressClose(viewModel: OtherBlikSettingsViewModel)
    func didUpdateForm(viewModel: OtherBlikSettingsViewModel)
}

final class OtherBlikSettingsPresenter: OtherBlikSettingsPresenterProtocol {
    private let coordinator: OtherBlikSettingsCoordinatorProtocol
    private var initialViewModel: OtherBlikSettingsViewModel
    private var confirmationDialogFactory: ConfirmationDialogProducing
    private var viewModelValidator: OtherBlikSettingsViewModelValidating
    weak var view: OtherBlikSettingsViewController?
    
    init(viewModel: OtherBlikSettingsViewModel,
         confirmationDialogFactory: ConfirmationDialogProducing = ConfirmationDialogFactory(),
         viewModelValidator: OtherBlikSettingsViewModelValidating = OtherBlikSettingsViewModelValidator(),
         coordinator: OtherBlikSettingsCoordinatorProtocol) {
        self.initialViewModel = viewModel
        self.confirmationDialogFactory = confirmationDialogFactory
        self.viewModelValidator = viewModelValidator
        self.coordinator = coordinator
    }
    
    func viewDidLoad() {
        view?.setViewModel(viewModel: initialViewModel)
    }
    
    func didPressSave(viewModel: OtherBlikSettingsViewModel) {
        //TODO:- Add usecase
        
        view?.showSnackbar(
            message: localized("pl_blik_text_settingsChangedSuccess"),
            type: .success
        )
    }

    func didPressClose(viewModel: OtherBlikSettingsViewModel) {
        guard let view = view else { return }
        
        let didBlikCustomerLabelChange = viewModel.blikCustomerLabel != initialViewModel.blikCustomerLabel
        let didTransactionVisibilityChange = viewModel.isTransactionVisible != initialViewModel.isTransactionVisible

        guard !didBlikCustomerLabelChange && !didTransactionVisibilityChange else {
            confirmationDialogFactory.createEndProcessDialog {[weak self] in
                self?.coordinator.close()
            } declineAction: {
            }.showIn(view)
            return
        }
        
        coordinator.close()
    }
    
    func didUpdateForm(viewModel: OtherBlikSettingsViewModel) {
        view?.setIsSaveButtonEnabled(viewModelValidator.validate(viewModel))
    }
}

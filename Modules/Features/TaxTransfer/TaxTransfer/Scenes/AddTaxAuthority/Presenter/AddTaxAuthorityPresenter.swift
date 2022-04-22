//
//  AddTaxAuthorityPresenter.swift
//  TaxTransfer
//
//  Created by 185167 on 15/02/2022.
//

import CoreFoundationLib
import PLUI

protocol AddTaxAuthorityPresenterProtocol {
    var view: AddTaxAuthorityView? { get set }
    func viewDidLoad()
    func didTapTaxSymbolSelector()
    func didTapCitySelector()
    func didTapTaxAuthoritySelector()
    func didUpdateIrpFields(
        taxAuthorityName: String?,
        accountNumber: String?
    )
    func didTapBack()
    func didTapClose()
    func didTapDone()
}

final class AddTaxAuthorityPresenter: AddTaxAuthorityPresenterProtocol {
    private let dependenciesResolver: DependenciesResolver
    private var form: TaxAuthorityForm
    weak var view: AddTaxAuthorityView?
    
    init(
        dependenciesResolver: DependenciesResolver,
        initialForm: TaxAuthorityForm
    ) {
        self.dependenciesResolver = dependenciesResolver
        self.form = initialForm
    }
    
    func viewDidLoad() {
        let viewModel = viewModelMapper.map(form)
        view?.setViewModel(viewModel)
    }
    
    func didTapTaxSymbolSelector() {
        coordinator.showTaxSymbolSelector(
            selectedTaxSymbol: form.selectedTaxSymbol,
            onSelection: { [weak self] taxSymbol in
                guard let strongSelf = self else { return }
                let newForm = strongSelf.getUpdatedForm(with: taxSymbol)
                strongSelf.updateForm(with: newForm)
            }
        )
    }
    
    func didTapCitySelector() {
        guard let selectedTaxSymbol = form.selectedTaxSymbol else { return }
        let input = GetTaxAuthorityCitiesUseCaseInput(taxTransferType: selectedTaxSymbol.symbolType)
        
        view?.showLoader()
        Scenario(useCase: getTaxAuthorityCitiesUseCase, input: input)
            .execute(on: useCaseHandler)
            .onSuccess { [weak self, form] output in
                self?.view?.hideLoader(completion: {
                    self?.coordinator.showCityNameSelector(
                        cities: output.taxAuthorityCities,
                        selectedCity: form.selectedCity,
                        onSelection: { taxAuthorityCity in
                            self?.handleSelectedCity(named: taxAuthorityCity.cityName)
                        }
                    )
                })
            }
            .onError { [weak self] _ in
                self?.view?.hideLoader(completion: {
                    self?.view?.showServiceInaccessibleMessage(onConfirm: nil)
                })
            }
    }
    
    func didTapTaxAuthoritySelector() {
        guard let selectedCity = form.selectedCity else { return }
        let input = GetTaxAccountsUseCaseInput(
            taxAccountNumberFilter: nil,
            taxAccountNameFilter: nil,
            cityFilter: selectedCity.cityName
        )
        
        view?.showLoader()
        Scenario(useCase: getTaxAccountsUseCase, input: input)
            .execute(on: useCaseHandler)
            .onSuccess { [weak self, form] output in
                self?.view?.hideLoader(completion: {
                    self?.coordinator.showTaxAccountSelector(
                        taxAccounts: output.taxAccounts,
                        selectedTaxAccount: form.selectedTaxAccount,
                        onSelection: { taxAuthorityAccount in
                            self?.handleSelectedTaxAuthorityAccount(taxAuthorityAccount)
                        }
                    )
                })
            }
            .onError { [weak self] _ in
                self?.view?.hideLoader(completion: {
                    self?.view?.showServiceInaccessibleMessage(onConfirm: nil)
                })
            }
    }
    
    func didUpdateIrpFields(
        taxAuthorityName: String?,
        accountNumber: String?
    ) {
        let newForm = getUpdatedForm(
            updatedTaxAuthorityName: taxAuthorityName,
            updatedAccountNumber: accountNumber
        )
        updateForm(with: newForm)
    }
    
    func didTapBack() {
        coordinator.back()
    }
    
    func didTapClose() {
        let dialog = confirmationDialogFactory.createEndProcessDialog(
            confirmAction: { [weak self] in
                self?.coordinator.close()
            },
            declineAction: {}
        )
        view?.showDialog(dialog)
    }
    
    func didTapDone() {
        do {
            let selectedTaxAuthority = try selectedTaxAuthorityMapper.map(form)
            coordinator.handleTaxAuthoritySelection(of: selectedTaxAuthority)
        } catch {
            assertionFailure("Button should be enabled only with valid filled form")
        }
    }
}

private extension AddTaxAuthorityPresenter {
    func handleSelectedCity(named cityName: String) {
        switch form {
        case let .us(form):
            let newForm = TaxAuthorityForm.us(
                UsTaxAuthorityForm(
                    taxSymbol: form.taxSymbol,
                    city: cityName,
                    taxAuthorityAccount: form.taxAuthorityAccount
                )
            )
            updateForm(with: newForm)
        case .formTypeUnselected, .irp:
            assertionFailure("Invalid form type - should be illegal")
        }
    }
    
    func handleSelectedTaxAuthorityAccount(_ taxAuthorityAccount: TaxAccount) {
        switch form {
        case let .us(form):
            let newForm = TaxAuthorityForm.us(
                UsTaxAuthorityForm(
                    taxSymbol: form.taxSymbol,
                    city: form.city,
                    taxAuthorityAccount: taxAuthorityAccount
                )
            )
            updateForm(with: newForm)
        case .formTypeUnselected, .irp:
            assertionFailure("Invalid form type - should be illegal")
        }
    }
    
    func updateForm(with newForm: TaxAuthorityForm) {
        form = newForm
        let viewModel = viewModelMapper.map(newForm)
        view?.setViewModel(viewModel)
        
        let validationResult = formValidator.validate(form)
        switch validationResult {
        case .valid:
            view?.setDoneButtonState(isEnabled: true)
            view?.clearInvalidFormMessages()
        case let .invalid(invalidFieldMessages):
            view?.setDoneButtonState(isEnabled: false)
            view?.setInvalidFormMessages(invalidFieldMessages)
        }
    }
    
    func getUpdatedForm(with taxSymbol: TaxSymbol) -> TaxAuthorityForm {
        switch (form, taxSymbol.destinationAccountType) {
        case let (.irp(currentForm), .IRP):
            let form = IrpTaxAuthorityForm(
                taxSymbol: taxSymbol,
                taxAuthorityName: currentForm.taxAuthorityName,
                accountNumber: currentForm.accountNumber
            )
            return .irp(form)
        case
            (.formTypeUnselected, .IRP),
            (.formTypeUnselected, .US),
            (.us, .IRP),
            (.irp, .US),
            (.us, .US):
            return getFreshForm(with: taxSymbol)
        }
    }
    
    func getUpdatedForm(
        updatedTaxAuthorityName: String?,
        updatedAccountNumber: String?
    ) -> TaxAuthorityForm {
        switch form {
        case let .irp(form):
            let form = IrpTaxAuthorityForm(
                taxSymbol: form.taxSymbol,
                taxAuthorityName: updatedTaxAuthorityName,
                accountNumber: updatedAccountNumber
            )
            return .irp(form)
        case let .us(form):
            assertionFailure("Invalid form type - should be illegal")
            return getFreshForm(with: form.taxSymbol)
        case .formTypeUnselected:
            assertionFailure("Invalid form type - should be illegal")
            return .formTypeUnselected
        }
    }
    
    func getFreshForm(with taxSymbol: TaxSymbol) -> TaxAuthorityForm {
        switch taxSymbol.destinationAccountType {
        case .US:
            let form = UsTaxAuthorityForm(
                taxSymbol: taxSymbol,
                city: nil,
                taxAuthorityAccount: nil
            )
            return .us(form)
        case .IRP:
            let form = IrpTaxAuthorityForm(
                taxSymbol: taxSymbol,
                taxAuthorityName: nil,
                accountNumber: nil
            )
            return .irp(form)
        }
    }
}

private extension AddTaxAuthorityPresenter {
    var coordinator: AddTaxAuthorityCoordinatorProtocol {
        dependenciesResolver.resolve()
    }
    
    var viewModelMapper: AddTaxAuthorityViewModelMapping {
        dependenciesResolver.resolve()
    }
    
    var useCaseHandler: UseCaseHandler {
        dependenciesResolver.resolve()
    }
    
    var getTaxAuthorityCitiesUseCase: GetTaxAuthorityCitiesUseCaseProtocol {
        dependenciesResolver.resolve()
    }
    
    var getTaxAccountsUseCase: GetTaxAccountsUseCaseProtocol {
        dependenciesResolver.resolve()
    }
    
    var selectedTaxAuthorityMapper: SelectedTaxAuthorityMapping {
        dependenciesResolver.resolve()
    }
    
    var formValidator: TaxAuthorityFormValidating {
        dependenciesResolver.resolve()
    }
    
    var confirmationDialogFactory: ConfirmationDialogProducing {
        dependenciesResolver.resolve()
    }
}

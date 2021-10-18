//
//  ChequeFormPresenter.swift
//  BLIK
//
//  Created by Piotr Mielcarzewicz on 07/07/2021.
//

import Commons
import DomainCommon
import UI

protocol ChequeFormPresenterProtocol {
    func viewDidLoad()
    func didPressClose()
    func didPressCreate()
    func didUpdateText()
}

final class ChequeFormPresenter: ChequeFormPresenterProtocol {
    private let dependenciesResolver: DependenciesResolver
    private let validator: ChequeFormValidating
    private let coordinator: ChequesCoordinatorProtocol
    private let createChequeUseCase: CreateChequeUseCaseProtocol
    private let viewModel: ChequeFormViewModel
    private var useCaseHandler: UseCaseHandler {
        return self.dependenciesResolver.resolve(for: UseCaseHandler.self)
    }
    weak var view: ChequeFormViewProtocol?
    
    init(
        dependenciesResolver: DependenciesResolver,
        validator: ChequeFormValidating,
        coordinator: ChequesCoordinatorProtocol,
        createChequeUseCase: CreateChequeUseCaseProtocol,
        amountLimit: String,
        currency: String
    ) {
        self.dependenciesResolver = dependenciesResolver
        self.validator = validator
        self.coordinator = coordinator
        self.createChequeUseCase = createChequeUseCase
        self.viewModel = ChequeFormViewModel(
            amountPlaceholder: localized("pl_blik_label_ChequeAmount"),
            amountCurrency: currency,
            amountLimit: amountLimit,
            selectedValidityPeriod: .hours24,
            namePlaceholder: localized("pl_blik_label_chequeName")
        )
    }
    
    func viewDidLoad() {
        view?.setViewModel(viewModel: viewModel)
    }
    
    func didPressClose() {
        coordinator.pop()
    }
    
    func didPressCreate() {
        guard let form = view?.getForm() else { return }
        switch validator.validate(form) {
        case let .valid(formRequest):
            view?.clearValidationMessages()
            createCheque(with: formRequest)
        case let .invalid(messages):
            view?.showInvalidFormMessages(messages)
        }
    }
    
    func didUpdateText() {
        guard let form = view?.getForm() else { return }
        switch validator.validate(form) {
        case .valid:
            view?.clearValidationMessages()
        case let .invalid(messages):
            view?.showInvalidFormMessages(messages)
        }
    }
    
    private func createCheque(with request: CreateChequeRequest) {
        view?.showLoader()
        Scenario(useCase: self.createChequeUseCase, input: request)
            .execute(on: useCaseHandler)
            .onSuccess { [weak self] _ in
                guard let strongSelf = self else { return }
                strongSelf.view?.hideLoader(completion: {
                    strongSelf.handleChequeCreation()
                })
            }
            .onError { [weak self] error in
                guard let strongSelf = self else { return }
                strongSelf.view?.hideLoader(completion: {
                    strongSelf.view?.showErrorMessage("#Nie udało się utworzyć czeku. Spróbuj ponownie później.", onConfirm: nil)
                })
            }
    }
    
    private func handleChequeCreation() {
        TopAlertController.setup(TopAlertView.self).showAlert(localized("pl_blik_alert_setPassText"), alertType: .info, position: .top)
        coordinator.pop()
    }
}

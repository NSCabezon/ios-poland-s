//
//  ChequePinPresenter.swift
//  BLIK
//
//  Created by 186491 on 03/06/2021.
//

import CoreFoundationLib

protocol ChequePinPresenterProtocol {
    func viewDidLoad()
    func didPressSave()
    func close()
}

final class ChequePinPresenter: ChequePinPresenterProtocol {
    private let dependenciesResolver: DependenciesResolver
    private let coordinator: ChequesCoordinatorProtocol
    private let saveChequePinUseCase: SaveChequePinUseCaseProtocol
    private let encryptChequePinUseCase: EncryptChequePinUseCaseProtocol
    private let validator: ChequePinValidating
    private let didSetPin: () -> Void
    private var useCaseHandler: UseCaseHandler {
        return self.dependenciesResolver.resolve(for: UseCaseHandler.self)
    }
    weak var view: ChequePinViewProtocol?
    var confirmationVisibility: ChequePinConfirmationFieldVisibility
    
    init(
        dependenciesResolver: DependenciesResolver,
        confirmationVisibility: ChequePinConfirmationFieldVisibility,
        coordinator: ChequesCoordinatorProtocol,
        saveChequePinUseCase: SaveChequePinUseCaseProtocol,
        encryptChequePinUseCase: EncryptChequePinUseCaseProtocol,
        validator: ChequePinValidating,
        didSetPin: @escaping () -> Void
    ) {
        self.dependenciesResolver = dependenciesResolver
        self.confirmationVisibility = confirmationVisibility
        self.coordinator = coordinator
        self.saveChequePinUseCase = saveChequePinUseCase
        self.encryptChequePinUseCase = encryptChequePinUseCase
        self.validator = validator
        self.didSetPin = didSetPin
    }
    
    func didPressSave() {
        guard let view = view else { return }
        let pin = ChequePin(pin: view.pin, pinConfirmation: view.pinConfirmation)
        switch validator.validate(pin: pin) {
        case .success:
            encryptAndSavePin(pin)
        case let .failure(error):
            showError(message: error.localizedString)
        }
    }
    
    func viewDidLoad() {
        view?.set(confirmationVisibility: confirmationVisibility)
    }
    
    func close() {
        coordinator.pop()
    }
    
    private func encryptAndSavePin(_ pin: ChequePin) {
        view?.showLoader()
        let input = EncryptChequePinUseCaseInput(chequePin: pin)
        Scenario(useCase: encryptChequePinUseCase, input: input)
            .execute(on: useCaseHandler)
            .onSuccess { [weak self] params in
                self?.save(encryptedPin: params)
            }
            .onError { [weak self] error in
                self?.view?.hideLoader(completion: {
                    self?.showError(message: error.localizedDescription)
                })
            }
    }
    
    private func save(encryptedPin: String) {
        let input = SaveChequePinUseCaseInput(encryptedPin: encryptedPin)
        Scenario(useCase: saveChequePinUseCase, input: input)
            .execute(on: useCaseHandler)
            .onSuccess { [weak self] params in
                self?.view?.hideLoader(completion: {
                    self?.didSetPin()
                })
            }
            .onError { [weak self] error in
                self?.view?.hideLoader(completion: {
                    self?.showError(message: error.localizedDescription)
                })
            }
    }
    
    private func showError(message: String) {
        view?.showSnackbar(message: message, type: .error)
    }
}


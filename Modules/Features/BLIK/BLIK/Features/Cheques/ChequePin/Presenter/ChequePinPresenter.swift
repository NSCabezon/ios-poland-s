//
//  ChequePinPresenter.swift
//  BLIK
//
//  Created by 186491 on 03/06/2021.
//

import Commons

protocol ChequePinPresenterProtocol {
    func viewDidLoad()
    func didPressSave()
    func close()
}

final class ChequePinPresenter: ChequePinPresenterProtocol {
    private let coordinator: ChequesCoordinatorProtocol
    private let saveChequePinUseCase: SaveChequePinUseCaseProtocol
    private let encryptChequePinUseCase: EncryptChequePinUseCaseProtocol
    private let validator: ChequePinValidating
    private let didSetPin: () -> Void
    
    weak var view: ChequePinViewProtocol?
    var confirmationVisibility: ChequePinConfirmationFieldVisibility
    
    init(confirmationVisibility: ChequePinConfirmationFieldVisibility,
         coordinator: ChequesCoordinatorProtocol,
         saveChequePinUseCase: SaveChequePinUseCaseProtocol,
         encryptChequePinUseCase: EncryptChequePinUseCaseProtocol,
         validator: ChequePinValidating,
         didSetPin: @escaping () -> Void
    ) {
        self.confirmationVisibility = confirmationVisibility
        self.coordinator = coordinator
        self.saveChequePinUseCase = saveChequePinUseCase
        self.encryptChequePinUseCase = encryptChequePinUseCase
        self.validator = validator
        self.didSetPin = didSetPin
    }
    
    func didPressSave() {
        encryptAndSavePin()
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
    
    private func encryptAndSavePin() {
        guard let view = view else { return }
        
        let pin = ChequePin(pin: view.pin, pinConfirmation: view.pinConfirmation)
    }
    
    private func encryptAndSavePin(_ pin: ChequePin) {
        view?.showLoader()
        Scenario(useCase: encryptChequePinUseCase, input: pin)
            .execute(on: DispatchQueue.global())
            .onSuccess { [weak self] params in
                self?.save(enctiptedPin: params)
            }
            .onError { [weak self] error in
                self?.view?.hideLoader(completion: {
                    self?.showError(message: error.localizedDescription)
                })
            }
    }
    
    private func save(enctiptedPin: String) {
        Scenario(useCase: saveChequePinUseCase, input: enctiptedPin)
            .execute(on: DispatchQueue.global())
            .onSuccess { [weak self] params in
                self?.view?.hideLoader(completion: {
                    self?.view?.showSnackbar(
                        message: "#Gotowe! Ustawiono pin do czeków BLIK.",
                        type: .success
                    )
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


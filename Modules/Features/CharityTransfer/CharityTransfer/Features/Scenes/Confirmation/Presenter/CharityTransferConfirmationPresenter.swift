//
//  CharityTransferConfirmationPresenter.swift
//  CharityTransfer
//
//  Created by 187830 on 08/11/2021.
//

import Commons
import PLUI
import CoreDomain
import CoreFoundationLib
import PLCommons

protocol CharityTransferConfirmationPresenterProtocol {
    var view: CharityTransferConfirmationViewControllerProtocol? { get set }
    func goBack()
    func closeProcess()
    func confirmTapped()
    func viewDidLoad()
}

final class CharityTransferConfirmationPresenter {
    var view: CharityTransferConfirmationViewControllerProtocol?
    private let dependenciesResolver: DependenciesResolver
    private let model: CharityTransferModel?
    private let confirmationDialogFactory: ConfirmationDialogProducing = ConfirmationDialogFactory()
    private var useCaseHandler: UseCaseHandler {
        dependenciesResolver.resolve(for: UseCaseHandler.self)
    }
    
    init(dependenciesResolver: DependenciesResolver,
         model: CharityTransferModel?) {
        self.dependenciesResolver = dependenciesResolver
        self.model = model
    }
    
    private func prepareViewModel() {
        guard let model = model else { return }
        view?.setViewModel(CharityTransferConfirmationViewModel(transfer: model))
    }
}

extension CharityTransferConfirmationPresenter: CharityTransferConfirmationPresenterProtocol {

    func goBack() {
        coordinator.pop()
    }

    func closeProcess() {
        let dialog = confirmationDialogFactory.createEndProcessDialog { [weak self] in
            self?.coordinator.backToTransfer()
        }
        declineAction: {}
        view?.showDialog(dialog)
    }

    func confirmTapped() {
        // TODO Depends on TAP-2430
    }

    func viewDidLoad() {
        prepareViewModel()
    }

    func showServiceInaccessibleError() {
        view?.showServiceInaccessibleMessage { [weak self] in
            self?.coordinator.backToTransfer()
        }
    }

    func showError(with key: String) {
        view?.showErrorMessage(localized(key)) { [weak self] in
            self?.coordinator.backToTransfer()
        }
    }
}

private extension CharityTransferConfirmationPresenter {
    var coordinator: CharityTransferConfirmationCoordinatorProtocol {
        dependenciesResolver.resolve(for: CharityTransferConfirmationCoordinatorProtocol.self)
    }
}


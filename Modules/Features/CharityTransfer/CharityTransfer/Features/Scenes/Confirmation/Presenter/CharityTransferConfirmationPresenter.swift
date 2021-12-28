//
//  CharityTransferConfirmationPresenter.swift
//  CharityTransfer
//
//  Created by 187830 on 08/11/2021.
//

import Commons
import CoreDomain
import CoreFoundationLib
import PLCommons

protocol CharityTransferConfirmationPresenterProtocol {
    var view: CharityTransferConfirmationViewControllerProtocol? { get set }
    func goBack()
    func backToTransfer()
    func confirmTapped()
    func viewDidLoad()
}

final class CharityTransferConfirmationPresenter {
    var view: CharityTransferConfirmationViewControllerProtocol?
    private let dependenciesResolver: DependenciesResolver
    private let model: CharityTransferModel?
    private var useCaseHandler: UseCaseHandler {
        dependenciesResolver.resolve(for: UseCaseHandler.self)
    }
    private var acceptCharityTransactionUseCase: AcceptCharityTransactionProtocol {
        dependenciesResolver.resolve()
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
    
    func backToTransfer() {
        coordinator.backToTransfer()
    }
    
    func confirmTapped() {
        guard let model = model else { return }
        self.view?.showLoader()
        Scenario(useCase: acceptCharityTransactionUseCase,
                 input: .init(model: model))
            .execute(on: useCaseHandler)
            .onSuccess { [weak self] result in
                guard let self = self else { return }
                self.view?.hideLoader {
                    self.coordinator.showSummary(with: result.summary)
                }
            }
            .onError { [weak self] error in
                self?.view?.hideLoader {
                    let errorResult = AcceptCharityTransactionErrorResult(rawValue: error.getErrorDesc() ?? "")
                    switch errorResult {
                    case .noConnection:
                        self?.showError(with: "pl_generic_alert_textUnstableConnection")
                    case .insufficientFunds:
                        self?.showError(with: "pl_generic_alert_textNoFunds")
                    case .limitExceeded:
                        self?.showError(with: "pl_generic_alert_textDayLimit", nameImage: "icnAlert")
                    default:
                        self?.handleServiceInaccessible()
                    }
                }
            }
    }
    
    func viewDidLoad() {
        prepareViewModel()
    }

    func showError(with key: String, nameImage: String = "icnAlertError") {
        view?.showErrorMessage(localized(key), image: nameImage, onConfirm: { [weak self] in
            self?.coordinator.pop()
        })
    }
    
    func handleServiceInaccessible() {
        view?.showErrorMessage(localized("pl_generic_alert_textTryLater"), image: "icnAlertError", onConfirm: { [weak self] in
            self?.coordinator.backToTransfer()
        })
    }
}

private extension CharityTransferConfirmationPresenter {
    var coordinator: CharityTransferConfirmationCoordinatorProtocol {
        dependenciesResolver.resolve(for: CharityTransferConfirmationCoordinatorProtocol.self)
    }
}


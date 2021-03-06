//
//  TaxTransferConfirmationPresenter.swift
//  TaxTransfer
//
//  Created by 187831 on 28/03/2022.
//

import PLUI
import CoreFoundationLib
import SANPLLibrary
import PLCommonOperatives

protocol TaxTransferConfirmationPresenterProtocol {
    func didPressBack()
    func didPressClose()
    func viewDidLoad()
    func confirmTapped()
}

final class TaxTransferConfirmationPresenter {
    weak var view: TaxTransferConfirmationView?
    private let dependenciesResolver: DependenciesResolver
    private let model: TaxTransferModel
    
    init(dependenciesResolver: DependenciesResolver,
         model: TaxTransferModel) {
        self.dependenciesResolver = dependenciesResolver
        self.model = model
    }
}

extension TaxTransferConfirmationPresenter: TaxTransferConfirmationPresenterProtocol {
    func viewDidLoad() {
        prepareViewModel()
    }
    
    func didPressClose() {
        let dialog = confirmationDialogFactory.createEndProcessDialog { [weak self] in
            self?.coordinator.goToGlobalPosition()
        }
        declineAction: {}
        
        view?.showDialog(dialog)
    }
    
    func didPressBack() {
        coordinator.backToForm()
    }
    
    func confirmTapped() {
        view?.showLoader()
        guard let userId = try? managersProvider.getLoginManager().getAuthCredentials().userId else {
            view?.showLoader()
            return
        }
        let sendMoneyInput = mapper.map(model: model, userId: userId)
        let notifyDeviceInput = mapper.mapPartialNotifyDeviceInput(with: model)
        let authorizeTransactionInput = AuthorizeTransactionUseCaseInput(
            sendMoneyConfirmationInput: sendMoneyInput,
            partialNotifyDeviceInput: notifyDeviceInput
        )
        
        Scenario(useCase: AuthorizeTransactionUseCase(dependenciesResolver: dependenciesResolver),
                 input: authorizeTransactionInput)
            .execute(on: useCaseHandler)
            .onSuccess { [weak self] output in
                self?.view?.hideLoader {
                    self?.showAuthorization(
                        with: TaxTransferAuthorizationModel(
                            identifier: output.authorizationId,
                            challenge: output.pendingChallenge
                        )
                    )
                }
            }
            .onError { [weak self] error in
                self?.view?.hideLoader {
                    if let noConnectionError = AcceptTaxTransactionErrorResult(
                        rawValue: error.getErrorDesc() ?? ""
                    ) {
                        self?.showErrorMessage(error: noConnectionError.rawValue)
                        return
                    }
                    let error = error.getPLErrorDTO()
                    let taxError = TaxTransferError(with: error)
                    self?.showErrorMessage(error: taxError?.errorResult.rawValue ?? "")
                }
            }
    }
}

private extension TaxTransferConfirmationPresenter {
    var coordinator: TaxTransferConfirmationCoordinatorProtocol {
        dependenciesResolver.resolve()
    }
    
    var managersProvider: PLManagersProviderProtocol {
        dependenciesResolver.resolve()
    }
    
    var confirmationDialogFactory: ConfirmationDialogProducing {
        dependenciesResolver.resolve()
    }
    
    var useCaseHandler: UseCaseHandler {
        dependenciesResolver.resolve()
    }
    
    var authorizationHandler: ChallengesHandlerDelegate {
        dependenciesResolver.resolve()
    }
    
    var acceptTaxTransactionUseCase: AcceptTaxTransactionProtocol {
        dependenciesResolver.resolve()
    }
    
    var mapper: TaxTransferSendMoneyInputMapping {
        dependenciesResolver.resolve(for: TaxTransferSendMoneyInputMapping.self)
    }
    
    func prepareViewModel() {
        let confirmationViewModel = TaxTransferConfirmationViewModel(
            model: model,
            dependenciesResolver: dependenciesResolver
        )
        view?.set(viewModel: confirmationViewModel)
}
    func showAuthorization(with model: TaxTransferAuthorizationModel) {
        authorizationHandler.handle(model.challenge, authorizationId: "\(model.identifier)") { [weak self] result in
            switch result {
            case .handled:
                self?.startAcceptTransaction()
            default:
                self?.handleServiceInaccessible()
            }
        }
    }
    
    func startAcceptTransaction() {
        view?.showLoader()
        Scenario(useCase: acceptTaxTransactionUseCase,
                 input: .init(model: model))
            .execute(on: useCaseHandler)
            .onSuccess { [weak self] result in
                guard let self = self else { return }
                self.view?.hideLoader {
                    self.coordinator.closeAuthorizationFlow()
                    self.coordinator.showSummary(
                        with: result.summary,
                        transferModel: self.model
                    )
                }
            }
            .onError { [weak self] error in
                self?.view?.hideLoader {
                    self?.coordinator.closeAuthorizationFlow()
                    self?.showErrorMessage(error: error.getErrorDesc() ?? "")
                }
            }
    }
    
    func showErrorMessage(error: String) {
        let errorResult = AcceptTaxTransactionErrorResult(rawValue: error)
        switch errorResult {
        case .noConnection:
            showError(with: "pl_generic_alert_textUnstableConnection")
        case .accountOnBlacklist:
            showError(with: "pl_generic_error_transferAcceptedOnlyAtBranch")
        case .expressRecipientInactive:
            showError(with: "pl_generic_error_transferNotAcceptedInBeneficiaryBank")
        case .limitExceeded:
            showError(with: "pl_generic_alert_textDayLimit", nameImage: "icnAlert")
        default:
            handleServiceInaccessible()
        }
    }
    
    func showError(with key: String, nameImage: String = "icnAlertError") {
        view?.showErrorMessage(localized(key), image: nameImage, onConfirm: { [weak self] in
            self?.coordinator.backToForm()
        })
    }
    
    func handleServiceInaccessible() {
        view?.showErrorMessage(localized("pl_generic_alert_textTryLater"), image: "icnAlertError", onConfirm: { [weak self] in
            self?.coordinator.backToForm()
        })
    }
}

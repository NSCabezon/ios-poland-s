//
//  CharityTransferConfirmationPresenter.swift
//  CharityTransfer
//
//  Created by 187830 on 08/11/2021.
//

import CoreFoundationLib
import CoreDomain
import PLCommons
import PLCommonOperatives
import SANPLLibrary

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
    private var authorizationHandler: ChallengesHandlerDelegate {
        dependenciesResolver.resolve(for: ChallengesHandlerDelegate.self)
    }
    private var managersProvider: PLManagersProviderProtocol {
        dependenciesResolver.resolve(for: PLManagersProviderProtocol.self)
    }
    private var charityTransferSendMoneyInputMapper: CharityTransferSendMoneyInputMapping {
        dependenciesResolver.resolve(for: CharityTransferSendMoneyInputMapping.self)
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
        guard let userId = try? managersProvider.getLoginManager().getAuthCredentials().userId else {
            return
        }
        let sendMoneyInput = charityTransferSendMoneyInputMapper.map(with: model, userId: userId)
        let notifyDeviceInput = charityTransferSendMoneyInputMapper.mapPartialNotifyDeviceInput(with: model)
        let authorizeTransactionInput = AuthorizeTransactionUseCaseInput(sendMoneyConfirmationInput: sendMoneyInput, partialNotifyDeviceInput: notifyDeviceInput)
        
        Scenario(useCase: AuthorizeTransactionUseCase(dependenciesResolver: dependenciesResolver), input: authorizeTransactionInput)
            .execute(on: useCaseHandler)
            .onSuccess { [weak self] output in
                self?.view?.hideLoader {
                    self?.authorizationHandler.handle(output.pendingChallenge, authorizationId: "\(output.authorizationId)", completion: { [weak self] challangeRestult in
                        switch challangeRestult {
                        case .handled(_):
                            self?.startAcceptTransaction()
                        default:
                            self?.handleServiceInaccessible()
                        }
                    })
                }
            }
            .onError { [weak self] error in
                self?.view?.hideLoader {
                    if let noConnectionError = AcceptCharityTransactionErrorResult(rawValue: error.getErrorDesc() ?? "") {
                        self?.showErrorMessage(error: noConnectionError.rawValue)
                        return
                    }
                    let plError = error.getPLErrorDTO()
                    let charityError = CharityTransferError(with: plError)
                    self?.showErrorMessage(error: charityError?.errorResult.rawValue ?? "")
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
    
    func startAcceptTransaction() {
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
                    self?.showErrorMessage(error: error.getErrorDesc() ?? "")
                }
            }
    }
    
    func showErrorMessage(error: String) {
        let errorResult = AcceptCharityTransactionErrorResult(rawValue: error)
        switch errorResult {
        case .noConnection:
            self.showError(with: "pl_generic_alert_textUnstableConnection")
        case .limitExceeded:
            self.showError(with: "pl_generic_alert_textDayLimit", nameImage: "icnAlert")
        default:
            self.handleServiceInaccessible()
        }
    }
}

private extension CharityTransferConfirmationPresenter {
    var coordinator: CharityTransferConfirmationCoordinatorProtocol {
        dependenciesResolver.resolve(for: CharityTransferConfirmationCoordinatorProtocol.self)
    }
}


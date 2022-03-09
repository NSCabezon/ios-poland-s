//
//  TopUpConfirmationPresenter.swift
//  PhoneTopUp
//
//  Created by 188216 on 13/01/2022.
//

import CoreFoundationLib
import Foundation
import Operative
import PLCommons
import PLUI

protocol TopUpConfirmationPresenterProtocol: AnyObject {
    var view: TopUpConfirmationViewProtocol? { get set }
    func summaryBodyItemsModels() -> [OperativeSummaryStandardBodyItemViewModel]
    func didSelectBack()
    func didSelectClose()
    func didSelectSubmit()
}

final class TopUpConfirmationPresenter {
    // MARK: Properties
    weak var view: TopUpConfirmationViewProtocol?
    private let dependenciesResolver: DependenciesResolver
    private var coordinator: TopUpConfirmationCoordinatorProtocol?
    private let confirmationDialogFactory: ConfirmationDialogProducing
    private let authorizationHandler: ChallengesHandlerDelegate
    private let summaryMapper: TopUpSummaryMapping
    private let summary: TopUpModel
    
    // MARK: Lifecycle
    
    init(dependenciesResolver: DependenciesResolver, summary: TopUpModel) {
        self.dependenciesResolver = dependenciesResolver
        self.coordinator = dependenciesResolver.resolve(for: TopUpConfirmationCoordinatorProtocol.self)
        self.confirmationDialogFactory = dependenciesResolver.resolve(for: ConfirmationDialogProducing.self)
        self.authorizationHandler = dependenciesResolver.resolve(for: ChallengesHandlerDelegate.self)
        self.summaryMapper = dependenciesResolver.resolve(for: TopUpSummaryMapping.self)
        self.summary = summary
    }
}

extension TopUpConfirmationPresenter: TopUpConfirmationPresenterProtocol {
    func didSelectBack() {
        coordinator?.back()
    }
    
    func didSelectClose() {
        let dialog = confirmationDialogFactory.createEndProcessDialog { [weak self] in
            self?.coordinator?.close()
        } declineAction: {}
        view?.showDialog(dialog)
    }
    
    func didSelectSubmit() {
        view?.showLoader()
        let input = PerformTopUpTransactionUseCaseInput(
            sourceAccount: summary.account,
            topUpAccount: summary.topUpAccount,
            amount: summary.amount,
            recipientNumber: summary.recipientNumber,
            operatorId: summary.operatorId,
            date: summary.date
        )
        
        Scenario(useCase: AuthorizeTopUpTransactionUseCase(dependenciesResolver: dependenciesResolver), input: input)
            .execute(on: dependenciesResolver.resolve())
            .onSuccess { [weak self] output in
                self?.view?.hideLoader(completion: {
                    self?.authorizationHandler.handle(output.pendingChallenge, authorizationId: "\(output.authorizationId)") { [weak self] challengeResult in
                        switch(challengeResult) {
                        case .handled(_):
                            self?.performTopUpTransaction(transactionInput: input)
                        default:
                            self?.view?.showErrorMessage(localized("pl_generic_alert_textTryLater"), onConfirm: {})
                        }
                    }
                })
            }.onError { [weak self] error in
                self?.view?.hideLoader(completion: {
                    self?.view?.showErrorMessage(localized("pl_generic_alert_textTryLater"), onConfirm: {})
                })
            }
    }
    
    func performTopUpTransaction(transactionInput: PerformTopUpTransactionUseCaseInput) {
        view?.showLoader()
        Scenario(useCase: PerformTopUpTransactionUseCase(dependenciesResolver: dependenciesResolver), input: transactionInput)
            .execute(on: dependenciesResolver.resolve())
            .onSuccess { [weak self] output in
                self?.view?.hideLoader(completion: {
                    guard let self = self, output.reloadSuccessful else {
                        self?.view?.showErrorMessage(localized("pl_generic_alert_textTryLater"), onConfirm: {})
                        return
                    }
                    self.coordinator?.showSummary(with: self.summary)
                })
            }.onError { [weak self] error in
                self?.view?.hideLoader(completion: {
                    self?.view?.showErrorMessage(localized("pl_generic_alert_textTryLater"), onConfirm: {})
                })
            }
    }
    
    func summaryBodyItemsModels() -> [OperativeSummaryStandardBodyItemViewModel] {
        return summaryMapper.mapConfirmationSummary(model: summary)
    }
}

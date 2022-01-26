//
//  TopUpConfirmationPresenter.swift
//  PhoneTopUp
//
//  Created by 188216 on 13/01/2022.
//

import Commons
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
    private let summaryMapper: TopUpSummaryMapping
    private let summary: TopUpModel
    
    // MARK: Lifecycle
    
    init(dependenciesResolver: DependenciesResolver, summary: TopUpModel) {
        self.dependenciesResolver = dependenciesResolver
        self.coordinator = dependenciesResolver.resolve(for: TopUpConfirmationCoordinatorProtocol.self)
        self.confirmationDialogFactory = dependenciesResolver.resolve(for: ConfirmationDialogProducing.self)
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
        #warning("todo: API call will be implemented in another PR")
        coordinator?.showSummary(with: summary)
    }
    
    func summaryBodyItemsModels() -> [OperativeSummaryStandardBodyItemViewModel] {
        return summaryMapper.mapConfirmationSummary(model: summary)
    }
}

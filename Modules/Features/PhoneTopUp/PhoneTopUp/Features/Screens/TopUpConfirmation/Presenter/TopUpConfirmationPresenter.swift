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
}

final class TopUpConfirmationPresenter {
    // MARK: Properties
    weak var view: TopUpConfirmationViewProtocol?
    private let dependenciesResolver: DependenciesResolver
    private var coordinator: TopUpConfirmationCoordinatorProtocol?
    private let confirmationDialogFactory: ConfirmationDialogProducing
    private let summary: TopUpModel
    
    // MARK: Lifecycle
    
    init(dependenciesResolver: DependenciesResolver, summary: TopUpModel) {
        self.dependenciesResolver = dependenciesResolver
        self.coordinator = dependenciesResolver.resolve(for: TopUpConfirmationCoordinatorProtocol.self)
        self.confirmationDialogFactory = dependenciesResolver.resolve(for: ConfirmationDialogProducing.self)
        self.summary = summary
    }
    
    // MARK: Methods
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
    
    func summaryBodyItemsModels() -> [OperativeSummaryStandardBodyItemViewModel] {
        return [
            amountItemViewModel(),
            accountItemViewModel(),
            recipientItemViewModel(),
            dateItemViewModel()
        ]
    }
    
    private func amountItemViewModel() -> OperativeSummaryStandardBodyItemViewModel {
        return OperativeSummaryStandardBodyItemViewModel(
            title: localized("summary_item_amount"),
            subTitle: amountValueString(withAmountSize: 32.0)
        )
    }
    
    private func accountItemViewModel() -> OperativeSummaryStandardBodyItemViewModel {
        return OperativeSummaryStandardBodyItemViewModel(
            title: localized("pl_topup_label_summaryAccountSender"),
            subTitle: summary.account.name,
            info: "*" + (summary.account.number.substring(ofLast: 4) ?? "")
        )
    }
    
    private func recipientItemViewModel() -> OperativeSummaryStandardBodyItemViewModel {
        if let recipientName = summary.recipientName {
            return OperativeSummaryStandardBodyItemViewModel(
                title: localized("pl_topup_label_summaryRecip"),
                subTitle: recipientName,
                info: summary.recipientNumber
            )
        }
        
        return OperativeSummaryStandardBodyItemViewModel(
            title: localized("pl_topup_label_summaryRecip"),
            subTitle: summary.recipientNumber
        )
    }
    
    private func dateItemViewModel() -> OperativeSummaryStandardBodyItemViewModel {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        let dateString = dateFormatter.string(from: summary.date)
        return OperativeSummaryStandardBodyItemViewModel(
            title: localized("pl_topup_text_dateTransfer"),
            subTitle: dateString
        )
    }
    
    private func amountValueString(withAmountSize size: CGFloat) -> NSAttributedString {
        return PLAmountFormatter.amountString(
            amount: summary.amount,
            currency: .złoty,
            withAmountSize: size
        )
    }
}

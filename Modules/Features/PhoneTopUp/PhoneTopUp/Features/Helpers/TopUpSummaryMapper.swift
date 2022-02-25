//
//  TopUpSummaryMapper.swift
//  PhoneTopUp
//
//  Created by 188216 on 18/01/2022.
//

import CoreFoundationLib
import Foundation
import Operative
import PLCommons

protocol TopUpSummaryMapping: AnyObject {
    func mapConfirmationSummary(model: TopUpModel) -> [OperativeSummaryStandardBodyItemViewModel]
    func mapSuccessSummary(model: TopUpModel) -> [OperativeSummaryStandardBodyItemViewModel]
}

final class TopUpSummaryMapper: TopUpSummaryMapping {
    func mapConfirmationSummary(model: TopUpModel) -> [OperativeSummaryStandardBodyItemViewModel] {
        return [
            amountItemViewModel(from: model),
            accountItemViewModel(from: model),
            recipientItemViewModel(from: model),
            dateItemViewModel(from: model)
        ]
    }
    
    func mapSuccessSummary(model: TopUpModel) -> [OperativeSummaryStandardBodyItemViewModel] {
        return [
            amountItemViewModel(from: model),
            accountItemViewModel(from: model),
            recipientItemViewModel(from: model),
            transactionTypeItemViewModel(),
            dateItemViewModel(from: model)
        ]
    }
    
    private func amountItemViewModel(from model: TopUpModel) -> OperativeSummaryStandardBodyItemViewModel {
        return OperativeSummaryStandardBodyItemViewModel(
            title: localized("summary_item_amount"),
            subTitle: amountValueString(withAmountSize: 32.0, model: model)
        )
    }
    
    private func accountItemViewModel(from model: TopUpModel) -> OperativeSummaryStandardBodyItemViewModel {
        return OperativeSummaryStandardBodyItemViewModel(
            title: localized("pl_topup_label_summaryAccountSender"),
            subTitle: model.account.name,
            info: "*" + (model.account.number.substring(ofLast: 4) ?? "")
        )
    }
    
    private func recipientItemViewModel(from model: TopUpModel) -> OperativeSummaryStandardBodyItemViewModel {
        if let recipientName = model.recipientName {
            return OperativeSummaryStandardBodyItemViewModel(
                title: localized("pl_topup_label_summaryRecip"),
                subTitle: recipientName,
                info: model.recipientNumber
            )
        }
        
        return OperativeSummaryStandardBodyItemViewModel(
            title: localized("pl_topup_label_summaryRecip"),
            subTitle: model.recipientNumber
        )
    }
    
    private func dateItemViewModel(from model: TopUpModel) -> OperativeSummaryStandardBodyItemViewModel {
        let dateFormatter = PLTimeFormat.ddMMyyyyDotted.createDateFormatter()
        let dateString = dateFormatter.string(from: model.date)
        return OperativeSummaryStandardBodyItemViewModel(
            title: localized("pl_topup_text_dateTransfer"),
            subTitle: dateString
        )
    }
    
    private func amountValueString(withAmountSize size: CGFloat, model: TopUpModel) -> NSAttributedString {
        return PLAmountFormatter.amountString(
            amount: Decimal(model.amount),
            currency: .złoty,
            withAmountSize: size
        )
    }
    
    private func transactionTypeItemViewModel() -> OperativeSummaryStandardBodyItemViewModel {
        return OperativeSummaryStandardBodyItemViewModel(
            title: localized("pl_topup_label_transType"),
            subTitle: localized("pl_topup_label_transTypeText")
        )
    }
}

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
            accountItemViewModel(from: model, title: localized("pl_topup_label_summaryAccountSender")),
            recipientItemViewModel(from: model),
            dateItemViewModel(from: model, title: localized("pl_topup_text_dateTransfer"))
        ]
    }
    
    func mapSuccessSummary(model: TopUpModel) -> [OperativeSummaryStandardBodyItemViewModel] {
        return [
            amountItemViewModel(from: model),
            accountItemViewModel(from: model, title: localized("pl_topup_label_accountTransfter")),
            recipientItemViewModel(from: model),
            transactionTypeItemViewModel(),
            dateItemViewModel(from: model, title: localized("pl_topup_label_date"))
        ]
    }
    
    private func amountItemViewModel(from model: TopUpModel) -> OperativeSummaryStandardBodyItemViewModel {
        return OperativeSummaryStandardBodyItemViewModel(
            title: localized("summary_item_amount"),
            subTitle: amountValueString(withAmountSize: 32.0, model: model)
        )
    }
    
    private func accountItemViewModel(from model: TopUpModel, title: String) -> OperativeSummaryStandardBodyItemViewModel {
        let maskedAccountNumber = "*" + (model.account.number.substring(ofLast: 4) ?? "")
        return OperativeSummaryStandardBodyItemViewModel(
            title: title,
            subTitle: model.account.name,
            info: attributedInfoString(maskedAccountNumber)
        )
    }
    
    private func recipientItemViewModel(from model: TopUpModel) -> OperativeSummaryStandardBodyItemViewModel {
        let phoneNumberFormatter = PhoneNumberFormatter()
        let formattedRecipientNumber = phoneNumberFormatter.formatPhoneNumberText(model.recipientNumber)
        if let recipientName = model.recipientName {
            return OperativeSummaryStandardBodyItemViewModel(
                title: localized("pl_topup_label_summaryRecip"),
                subTitle: recipientName,
                info: attributedInfoString(formattedRecipientNumber)
            )
        }
        
        return OperativeSummaryStandardBodyItemViewModel(
            title: localized("pl_topup_label_summaryRecip"),
            subTitle: formattedRecipientNumber
        )
    }
    
    private func dateItemViewModel(from model: TopUpModel, title: String) -> OperativeSummaryStandardBodyItemViewModel {
        let dateFormatter = PLTimeFormat.ddMMyyyyDotted.createDateFormatter()
        let dateString = dateFormatter.string(from: model.date)
        return OperativeSummaryStandardBodyItemViewModel(
            title: title,
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
    
    private func attributedInfoString(_ string: String) -> NSAttributedString {
        let attributes: [NSAttributedString.Key: Any] = [.font: UIFont.santander(family: .micro, type: .regular, size: 14)]
        return NSAttributedString(string: string, attributes: attributes)
    }
}

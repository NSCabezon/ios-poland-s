//
//  TaxOperativeSummaryMapper.swift
//  TaxTransfer
//
//  Created by 187831 on 26/04/2022.
//

import UI
import Operative
import PLCommons
import CoreFoundationLib

protocol TaxOperativeSummaryMapping {
    func map(_ model: TaxTransferModel) -> [OperativeSummaryStandardBodyItemViewModel]
    func map(
        _ transferModel: TaxTransferModel,
        summaryModel: TaxTransferSummary
    ) -> [OperativeSummaryStandardBodyItemViewModel]
}

final class TaxOperativeSummaryMapper: TaxOperativeSummaryMapping {
    func map(_ model: TaxTransferModel) -> [OperativeSummaryStandardBodyItemViewModel] {
        let dateString = getDateString(from: model.date)
        let recipientName = model.recipientName ?? localized("pl_foundtrans_text_RecipFoudSant")
        let recipientAccountNumber = IBANFormatter.format(iban: model.recipientAccountNumber)
        let accountNumber = IBANFormatter.format(iban: model.account.number)
        let transferType: String = localized("pl_generic_label_exTransfer")
        let taxIdentifier = model.taxPayerInfo.idType.displayableValue + " - " + model.taxPayerInfo.taxIdentifier
        
        var items: [OperativeSummaryStandardBodyItemViewModel] = [
            .init(title: localized("pl_generic_label_amount"),
                  subTitle: amountValueString(model.amount, size: 32),
                  info: localized("pl_transferOption_button_transferTax")),
            .init(title: localized("pl_generic_label_accountToPayFrom"),
                  subTitle: model.account.name,
                  info: accountNumber),
            .init(title: localized("pl_generic_label_taxAuthority"),
                  subTitle: recipientName,
                  info: recipientAccountNumber),
            .init(title: localized("pl_generic_label_payer"),
                  subTitle: model.taxPayer.name ?? model.taxPayer.shortName,
                  info: taxIdentifier),
            .init(title: localized("pl_generic_label_formSymbol"),
                  subTitle: getTaxInfo(transferModel: model)),
        ]

        items.append(.init(title: localized("pl_generic_label_transactionType"),
                           subTitle: transferType)
        )
        items.append(.init(title: localized("pl_generic_label_data"),
                           subTitle: dateString)
        )
        return items
    }
    
    func map(_ transferModel: TaxTransferModel, summaryModel: TaxTransferSummary) -> [OperativeSummaryStandardBodyItemViewModel] {
        let taxIdentifier = transferModel.taxPayerInfo.idType.displayableValue + " - " + transferModel.taxPayerInfo.taxIdentifier
        let taxPayer = transferModel.taxPayer.name ?? transferModel.taxPayer.shortName
        
        var items: [OperativeSummaryStandardBodyItemViewModel] = [
            .init(
                title: localized("pl_generic_label_amount"),
                subTitle: PLAmountFormatter.amountString(
                    amount: summaryModel.amount,
                    currency: summaryModel.currency,
                    withAmountSize: 32
                ),
                info: localized("pl_transferOption_button_transferTax")
            ),
            .init(title: localized("pl_generic_label_accountToPayFrom"),
                  subTitle: summaryModel.accountName,
                  info: summaryModel.accountNumber),
            .init(title: localized("pl_generic_label_taxAuthority"),
                  subTitle: summaryModel.recipientName,
                  info: summaryModel.recipientAccountNumber),
            .init(title: localized("pl_generic_label_payer"),
                  subTitle: taxPayer,
                  info: taxIdentifier),
            .init(title: localized("pl_generic_label_formSymbol"),
                  subTitle: getTaxInfo(transferModel: transferModel))
        ]

        items.append(.init(title: localized("pl_generic_label_transactionType"),
                               subTitle: localized("pl_generic_label_exTransfer")))
        items.append(.init(title: localized("pl_generic_label_data"),
                               subTitle: summaryModel.dateString))
        return items
    }

}
    
private extension TaxOperativeSummaryMapper {
    var attributedTitle: [NSAttributedString.Key: NSObject] {
        [
            NSAttributedString.Key.foregroundColor: UIColor.grafite,
            NSAttributedString.Key.font: UIFont.santander(family: .text, type: .regular, size: 13)
        ]
    }
    
    var attributedSubtitle: [NSAttributedString.Key: NSObject] {
        [
            NSAttributedString.Key.foregroundColor: UIColor.lisboaGray,
            NSAttributedString.Key.font: UIFont.santander(family: .text, type: .bold, size: 14)
        ]
    }

    func amountValueString(_ amount: Decimal, size: CGFloat) -> NSAttributedString {
        PLAmountFormatter.amountString(
            amount: amount,
            currency: .złoty,
            withAmountSize: size
        )
    }
    
    func getDateString(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = PLTimeFormat.ddMMyyyyDotted.rawValue
        return dateFormatter.string(from: date)
    }
    
    func getTaxInfo(transferModel: TaxTransferModel) -> NSAttributedString {
        let formSymbolSubtitle = AttributedStringBuilder(
            string: transferModel.taxSymbol.name,
            properties: attributedSubtitle
        ).build()
        
        let billingPeriod = getBillingPeriod(
            year: transferModel.billingYear ?? "",
            periodType: transferModel.billingPeriodType,
            billingPeriodNumber: transferModel.billingPeriodNumber
        )
        let period = getAttributedString(
            billingPeriod,
            title: localized("pl_generic_label_period")
        )
        let obligationIdentifier = getAttributedString(
            transferModel.obligationIdentifier,
            title: localized("pl_taxTransfer_label_financialObligationId")
        )
        let attributedAccountDetails = NSMutableAttributedString()
        
        [
            formSymbolSubtitle,
            period,
            obligationIdentifier
        ].forEach {
            attributedAccountDetails.append($0)
        }
        
        return attributedAccountDetails
    }

    func getAttributedString(_ text: String, title: String) -> NSAttributedString {
        guard text.isNotEmpty else {
            return NSAttributedString(string: "")
        }
        
        let title = AttributedStringBuilder(
            string: ["\n", title].joined(),
            properties: attributedTitle
        ).build()
        
        let subtitle = AttributedStringBuilder(
            string: ["\n", text].joined(),
            properties: attributedSubtitle
        ).build()
        
        let attributedAccountDetails = NSMutableAttributedString()
        [
            title,
            subtitle
        ].forEach {
            attributedAccountDetails.append($0)
        }
        return attributedAccountDetails
    }
    
    func getBillingPeriod(
        year: String,
        periodType: TaxTransferBillingPeriodType?,
        billingPeriodNumber: Int?
    ) -> String {
        guard !year.isEmpty else {
            return ""
        }
        var billingPeriod = localized("pl_taxTransfer_tab_year") + ": " + year
        
        if periodType != .year {
            billingPeriod = billingPeriod.appending("\n" + (periodType?.name ?? "") + ": " + "\(billingPeriodNumber ?? 0)")
        }
        return billingPeriod
    }
}

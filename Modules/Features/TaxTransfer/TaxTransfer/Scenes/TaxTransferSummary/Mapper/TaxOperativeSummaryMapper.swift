//
//  TaxOperativeSummaryMapper.swift
//  TaxTransfer
//
//  Created by 187831 on 26/04/2022.
//

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
        let title = model.title ?? ""
        let dateString = getDateString(from: model.date)
        let recipientName = model.recipientName ?? localized("pl_foundtrans_text_RecipFoudSant")
        let recipientAccountNumber = IBANFormatter.format(iban: model.recipientAccountNumber)
        let accountNumber = IBANFormatter.format(iban: model.account.number)
        let transferType: String = localized("pl_generic_label_exTransfer")
        let taxIdentifier = model.taxPayerInfo.idType.displayableValue + " - " + model.taxPayerInfo.taxIdentifier
        let billingPeriod = getBillingPeriod(
            year: model.billingYear ?? "",
            periodType: model.billingPeriodType,
            billingPeriodNumber: model.billingPeriodNumber
        )
        
        var items: [OperativeSummaryStandardBodyItemViewModel] = [
            .init(title: localized("pl_generic_label_amount"),
                  subTitle: amountValueString(model.amount, size: 32),
                  info: title),
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
                  subTitle: model.taxSymbol.name),
        ]
        
        if !billingPeriod.isEmpty {
            items.append(.init(title: localized("pl_generic_label_period"),
                               subTitle: billingPeriod)
            )
        }
        
        if !model.obligationIdentifier.isEmpty {
            items.append(.init(title: localized("pl_taxTransfer_label_financialObligationId"),
                               subTitle: model.obligationIdentifier)
            )
        }

        items.append(.init(title: localized("pl_generic_label_transactionType"),
                           subTitle: transferType)
        )
        items.append(.init(title: localized("pl_generic_label_data"),
                           subTitle: dateString)
        )
        return items
    }
    
    func map(_ transferModel: TaxTransferModel, summaryModel: TaxTransferSummary) -> [OperativeSummaryStandardBodyItemViewModel] {
        
        let billingPeriod = getBillingPeriod(
            year: transferModel.billingYear ?? "",
            periodType: transferModel.billingPeriodType,
            billingPeriodNumber: transferModel.billingPeriodNumber
        )
        
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
                info: summaryModel.title
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
                  subTitle: transferModel.taxSymbol.name)
        ]

        if !billingPeriod.isEmpty {
            items.append(.init(title: localized("pl_generic_label_period"),
                               subTitle: billingPeriod)
            )
        }
        
        if !transferModel.obligationIdentifier.isEmpty {
            items.append(.init(title: localized("pl_taxTransfer_label_financialObligationId"),
                               subTitle: transferModel.obligationIdentifier)
            )
        }
        items.append(.init(title: localized("pl_generic_label_transactionType"),
                               subTitle: localized("pl_generic_label_exTransfer")))
        items.append(.init(title: localized("pl_generic_label_data"),
                               subTitle: summaryModel.dateString))
        return items
    }
    
    private func amountValueString(_ amount: Decimal, size: CGFloat) -> NSAttributedString {
        PLAmountFormatter.amountString(
            amount: amount,
            currency: .złoty,
            withAmountSize: size
        )
    }
    
    private func getDateString(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = PLTimeFormat.ddMMyyyyDotted.rawValue
        return dateFormatter.string(from: date)
    }
    
    private func getBillingPeriod(
        year: String,
        periodType: TaxTransferBillingPeriodType,
        billingPeriodNumber: Int?
    ) -> String {
        var billingPeriod = localized("pl_taxTransfer_tab_year") + ": " + year
        
        if periodType != .year {
            billingPeriod = billingPeriod.appending("\n" + periodType.name + ": " + "\(billingPeriodNumber ?? 0)")
        }
        return billingPeriod
    }
}

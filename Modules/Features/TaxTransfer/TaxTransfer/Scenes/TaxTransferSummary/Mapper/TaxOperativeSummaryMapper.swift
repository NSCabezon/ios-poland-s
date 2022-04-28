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
        let transferType: String = localized("#Przelew zewnętrzny")
        let taxIdentifier = model.taxPayerInfo.idType.displayableValue + " - " + model.taxPayerInfo.taxIdentifier
        let billingPeriod = getBillingPeriod(
            year: model.billingYear ?? "",
            periodType: model.billingPeriodType,
            billingPeriodNumber: model.billingPeriodNumber
        )
        
        var items: [OperativeSummaryStandardBodyItemViewModel] = [
            .init(title: localized("#Kwota"),
                  subTitle: amountValueString(model.amount, size: 32),
                  info: title),
            .init(title: localized("#Konto, z którego robisz przelew"),
                  subTitle: model.account.name,
                  info: accountNumber),
            .init(title: localized("#Dane organu podatkowego"),
                  subTitle: recipientName,
                  info: recipientAccountNumber),
            .init(title: "#Dane płatnika",
                  subTitle: model.taxPayer.name ?? model.taxPayer.shortName,
                  info: taxIdentifier),
            .init(title: "#Symbol formularza lub płatności",
                  subTitle: model.taxSymbol.name),
        ]
        
        if !billingPeriod.isEmpty {
            items.append(.init(title: "#Okres",
                               subTitle: billingPeriod)
            )
        }
        
        if !model.obligationIdentifier.isEmpty {
            items.append(.init(title: "#Identyfikacja zobowiązania",
                               subTitle: model.obligationIdentifier)
            )
        }

        items.append(.init(title: localized("#Typ transakcji"),
                           subTitle: transferType)
        )
        items.append(.init(title: localized("#Data"),
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
                title: "#Kwota",
                subTitle: PLAmountFormatter.amountString(
                    amount: summaryModel.amount,
                    currency: summaryModel.currency,
                    withAmountSize: 32
                ),
                info: summaryModel.title
            ),
            .init(title: localized("#Konto, z którego robisz przelew"),
                  subTitle: summaryModel.accountName,
                  info: summaryModel.accountNumber),
            .init(title: "#Dane organu podatkowego",
                  subTitle: summaryModel.recipientName,
                  info: summaryModel.recipientAccountNumber),
            .init(title: "#Dane płatnika",
                  subTitle: taxPayer,
                  info: taxIdentifier),
            .init(title: "#Symbol formularza lub płatności",
                  subTitle: transferModel.taxSymbol.name)
        ]

        if !billingPeriod.isEmpty {
            items.append(.init(title: "#Okres",
                               subTitle: billingPeriod)
            )
        }
        
        if !transferModel.obligationIdentifier.isEmpty {
            items.append(.init(title: "#Identyfikacja zobowiązania",
                               subTitle: transferModel.obligationIdentifier)
            )
        }
        items.append(.init(title: "#Typ transakcji",
                               subTitle: "#Przelew zewnętrzny"))
        items.append(.init(title: "#Data",
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

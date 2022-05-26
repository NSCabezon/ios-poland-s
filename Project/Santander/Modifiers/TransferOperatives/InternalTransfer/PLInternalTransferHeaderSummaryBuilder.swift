//
//  PLInternalTransferHeaderSummaryBuilder.swift
//  Santander
//
//  Created by Cristobal Ramos Laina on 31/3/22.
//

import Foundation
import CoreFoundationLib
import CoreDomain
import UIOneComponents
import TransferOperatives

final class PLInternalTransferHeaderSummaryBuilder: InternalTransferHeaderSummaryBuilder {
    private let dependencies: InternalTransferSummaryExternalDependenciesResolver
    private var operativeData: InternalTransferOperativeData?
    private var summaryItems: [OneListFlowItemViewModel] = []
    private var defaultCurrency: CurrencyType = NumberFormattingHandler.shared.getDefaultCurrency()
    private lazy var modifier: InternalTransferSummaryModifierProtocol = dependencies.resolve()
    
    init(dependencies: InternalTransferSummaryExternalDependenciesResolver) {
        self.dependencies = dependencies
    }
    
    func setOperativeData(_ operativeData: InternalTransferOperativeData) {
        self.operativeData = operativeData
    }
    
    func addSummaryItems() {
        addSourceAccount()
        addAmountOrExchangeRate()
        addSendDate()
        addSendType()
        addDestinationAccount()
    }
    
    func addSourceAccount() {
        guard let operativeData = operativeData else { return }
        var items: [OneListFlowItemViewModel.Item] = [
            .init(type: .title(keyOrValue: "summary_label_originAccount"),
                  accessibilityId: AccessibilityOneComponents.oneListFlowItemTitle)
            ]
        if let originFullName = operativeData.originFullName {
            items.append(.init(type: .label(keyOrValue: originFullName,
                                            isBold: true),
                               accessibilityId: AccessibilityOneComponents.oneListFlowItemText))
        }
        items.append(.init(type: .label(keyOrValue: operativeData.originAccount?.alias,
                                        isBold: true),
                           accessibilityId: AccessibilityOneComponents.oneListFlowItemText + "1"))
        items.append(.init(type: .label(keyOrValue: operativeData.originAccount?.getIBANPapel,
                                        isBold: false),
                           accessibilityId: AccessibilityOneComponents.oneListFlowItemInfo + "1"))
        items.append(.init(type: .image(imageKeyOrUrl: bankLogoURLFrom(ibanRepresentable: operativeData.originAccount?.ibanRepresentable)),
                           accessibilityId: AccessibilityOneComponents.oneListFlowItemIcn))
        append(items, suffix: AccessibilityInternalTransferSummary.Summary.sourceSuffix, isFirstItem: true)
    }
    
    func addAmount() {
        guard let operativeData = operativeData,
              let amount = operativeData.amount else { return }
        let items: [OneListFlowItemViewModel.Item] = [
            .init(type: .title(keyOrValue: "summary_item_amountDescription"),
                  accessibilityId: AccessibilityOneComponents.oneListFlowItemTitle),
            .init(type: .attributedLabel(attributedString: getFormattedAmountWithCurrency(amount: amount,
                                                                                          font: .oneB300Bold,
                                                                                          decimalFont: .oneB300Bold)),
                  accessibilityId: AccessibilityOneComponents.oneListFlowItemText),
            .init(type: .label(keyOrValue: operativeData.description ?? "summary_label_transferOwnAccount",
                               isBold: false),
                  accessibilityId: AccessibilityOneComponents.oneListFlowItemInfo + "1")
        ]
        append(items, suffix: AccessibilityInternalTransferSummary.Summary.amountSuffix)
    }
    
    func addAmountOrExchangeRate() {
        guard let operativeData = operativeData else { return }
        switch operativeData.transferType {
        case .doubleExchange(sellExchange: let sellRate, buyExchange: let buyRate):
            addTwoConversionsType(sellRate: sellRate, buyRate: buyRate)
        case .simpleExchange(sellExchange: let rate):
            addOneConversionType(rate: rate)
        case .noExchange, .none:
            addAmount()
        }
    }
    
    func addSendType() {
        guard let operativeData = operativeData,
              let originAccount = operativeData.originAccount,
              let destinationAccount = operativeData.destinationAccount else { return }
        var items: [OneListFlowItemViewModel.Item] = [
            .init(type: .title(keyOrValue: "confirmation_label_sendType"),
                  accessibilityId: AccessibilityOneComponents.oneListFlowItemTitle)
        ]
        if modifier.freeTransferFor(originAccount: originAccount,
                                    destinationAccount: destinationAccount,
                                    date: operativeData.issueDate) {
            items.append(.init(type: .tag(tag: .init(itemKeyOrValue: "summary_label_internalTransfer", tagKeyOrValue: localized("sendMoney_tag_free"))),
                               accessibilityId: AccessibilityOneComponents.oneListFlowItemTag))
        } else {
            items.append(.init(type: .label(keyOrValue: "summary_label_internalTransfer", isBold: true),
                               accessibilityId: AccessibilityOneComponents.oneListFlowItemText))
        }
        append(items, suffix: AccessibilityInternalTransferConfirmation.typeSuffix)
    }
    
    func addSendDate() {
        guard let operativeData = operativeData else { return }
        let date = operativeData.issueDate.toString(format: TimeFormat.dd_MM_yyyy.rawValue)
        let dateString = operativeData.issueDate.isDayInToday() ? "confirmation_label_today" : date
        var items: [OneListFlowItemViewModel.Item] = [
            .init(type: .title(keyOrValue: "summary_label_sendDate"),
                  accessibilityId: AccessibilityOneComponents.oneListFlowItemTitle)
        ]
        items.append(.init(type: .label(keyOrValue: dateString, isBold: true),
                           accessibilityId: AccessibilityOneComponents.oneListFlowItemText))
        append(items, suffix: AccessibilityInternalTransferSummary.Summary.dateSuffix)
    }
    
    func addDestinationAccount() {
        guard let operativeData = operativeData else { return }
        var items: [OneListFlowItemViewModel.Item] = [
            .init(type: .title(keyOrValue: "confirmation_label_destinationAccount"),
                  accessibilityId: AccessibilityOneComponents.oneListFlowItemTitle)
            ]
        if let destinationFullName = operativeData.destinationFullName {
            items.append(.init(type: .label(keyOrValue: destinationFullName, isBold: true),
                               accessibilityId: AccessibilityOneComponents.oneListFlowItemText))
        }
        items.append(.init(type: .label(keyOrValue: operativeData.destinationAccount?.alias, isBold: true),
                           accessibilityId: AccessibilityOneComponents.oneListFlowItemText +  "1"))
        items.append(.init(type: .label(keyOrValue: operativeData.destinationAccount?.getIBANPapel, isBold: false),
                           accessibilityId: AccessibilityOneComponents.oneListFlowItemInfo + "1"))
        items.append(.init(type: .image(imageKeyOrUrl: bankLogoURLFrom(ibanRepresentable: operativeData.destinationAccount?.ibanRepresentable)),
                           accessibilityId: AccessibilityOneComponents.oneListFlowItemIcn))
        append(items, suffix: AccessibilityInternalTransferSummary.Summary.destinationSuffix, isLastItem: true)
    }
    
    func build() -> [OneListFlowItemViewModel] {
        return summaryItems
    }
}

private extension PLInternalTransferHeaderSummaryBuilder {
    func append(_ items: [OneListFlowItemViewModel.Item], suffix: String, isFirstItem: Bool = false, isLastItem: Bool = false) {
        summaryItems.append(
            OneListFlowItemViewModel(
                isFirstItem: isFirstItem,
                isLastItem: isLastItem,
                items: items,
                accessibilitySuffix: suffix
            )
        )
    }
    
    func bankLogoURLFrom(ibanRepresentable: IBANRepresentable?) -> String? {
        return ibanRepresentable?.bankLogoURLFrom(baseURLProvider: dependencies.resolve())
    }
    
    func getFormattedAmountWithCurrency(amount: AmountRepresentable, font: FontName, decimalFont: FontName) -> NSAttributedString {
        let decorator = AmountRepresentableDecorator(
            amount,
            font: .typography(fontName: font),
            decimalFont: .typography(fontName: decimalFont)
        )
        return decorator.getFormatedWithCurrencyName() ?? NSAttributedString()
    }
    
    func addOneConversionType(rate: InternalTransferExchangeType) {
        guard let operativeData = operativeData,
              let receiveAmount = operativeData.receiveAmount,
              let amount = operativeData.amount,
              let rateValue = rate.rate else { return }
        let localCurrency = defaultCurrency.rawValue
        let foreignCurrency = rate.originCurrency.currencyType.rawValue != localCurrency ? rate.originCurrency : rate.destinationCurrency
        let conversionString = String(format: "1 %@ = %.4f %@", foreignCurrency.currencyType.rawValue, rateValue.doubleValue, localCurrency)
        let items: [OneListFlowItemViewModel.Item] = [
            .init(type: .title(keyOrValue: "summary_label_recipientWillReceive"),
                  accessibilityId: AccessibilityOneComponents.oneListFlowItemTitle),
            .init(type: .attributedLabel(attributedString: getFormattedAmountWithCurrency(amount: receiveAmount,
                                                                                          font: .oneH500Bold,
                                                                                          decimalFont: .oneB400Bold)),
                  accessibilityId: AccessibilityOneComponents.oneListFlowItemInfo),
            .init(type: .title(keyOrValue: "summary_label_transferOwnAccount"),
                  accessibilityId: AccessibilityOneComponents.oneListFlowItemTitle + "1"),
            .init(type: .title(keyOrValue: getExchangeString()),
                  accessibilityId: AccessibilityOneComponents.oneListFlowItemTitle + "2"),
            .init(type: .label(keyOrValue: conversionString, isBold: true),
                  accessibilityId: AccessibilityOneComponents.oneListFlowItemText),
            .init(type: .label(keyOrValue: "summary_item_amountAfterConversion", isBold: false),
                  accessibilityId: AccessibilityOneComponents.oneListFlowItemText + "1"),
            .init(type: .attributedLabel(attributedString: getFormattedAmountWithCurrency(amount: amount,
                                                                                          font: .oneB300Bold,
                                                                                          decimalFont: .oneB300Bold)),
                  accessibilityId: AccessibilityOneComponents.oneListFlowItemInfo + "1")
        ]
        append(items, suffix: AccessibilityInternalTransferSummary.Summary.exchangeSuffix)
    }
    
    func addTwoConversionsType(sellRate: InternalTransferExchangeType, buyRate: InternalTransferExchangeType) {
        guard let operativeData = operativeData,
              let receiveAmount = operativeData.receiveAmount,
              let amount = operativeData.amount,
              let sellRateValue = sellRate.rate,
              let buyRateValue = buyRate.rate else { return }
        let localCurrency = defaultCurrency.rawValue
        let fromCurrency = sellRate.originCurrency.currencyType.rawValue
        let toCurrency = buyRate.originCurrency.currencyType.rawValue
        let sellConversionString = String(format: "1 %@ = %.4f %@", fromCurrency, sellRateValue.doubleValue, localCurrency)
        let buyConversionString = String(format: "1 %@ = %.4f %@", toCurrency, buyRateValue.doubleValue, localCurrency)
        let items: [OneListFlowItemViewModel.Item] = [
            .init(type: .title(keyOrValue: "summary_label_recipientWillReceive"),
                  accessibilityId: AccessibilityOneComponents.oneListFlowItemTitle),
            .init(type: .attributedLabel(attributedString: getFormattedAmountWithCurrency(amount: receiveAmount,
                                                                                          font: .oneH500Bold,
                                                                                          decimalFont: .oneB400Bold)),
                  accessibilityId: AccessibilityOneComponents.oneListFlowItemInfo),
            .init(type: .title(keyOrValue: "summary_label_transferOwnAccount"),
                  accessibilityId: AccessibilityOneComponents.oneListFlowItemTitle + "1"),
            .init(type: .title(keyOrValue: "summary_item_exchangeBuyRate"),
                  accessibilityId: AccessibilityOneComponents.oneListFlowItemTitle + "2"),
            .init(type: .label(keyOrValue: sellConversionString, isBold: true),
                  accessibilityId: AccessibilityOneComponents.oneListFlowItemText),
            .init(type: .title(keyOrValue: "summary_item_exchangeSellRate"),
                  accessibilityId: AccessibilityOneComponents.oneListFlowItemTitle + "3"),
            .init(type: .label(keyOrValue: buyConversionString, isBold: true),
                  accessibilityId: AccessibilityOneComponents.oneListFlowItemText + "1"),
            .init(type: .label(keyOrValue: "summary_item_amountAfterConversion", isBold: false),
                  accessibilityId: AccessibilityOneComponents.oneListFlowItemText + "2"),
            .init(type: .attributedLabel(attributedString: getFormattedAmountWithCurrency(amount: amount,
                                                                                          font: .oneB300Bold,
                                                                                          decimalFont: .oneB300Bold)),
                  accessibilityId: AccessibilityOneComponents.oneListFlowItemInfo + "1")
        ]
        append(items, suffix: AccessibilityInternalTransferSummary.Summary.exchangeSuffix)
    }
    
    func getExchangeString() -> String {
        guard let operativeData = operativeData else { return "" }
        if defaultCurrency == operativeData.originAccount?.currencyRepresentable?.currencyType {
            return "summary_item_exchangeSellRate"
        } else {
            return "summary_item_exchangeBuyRate"
        }
    }
}

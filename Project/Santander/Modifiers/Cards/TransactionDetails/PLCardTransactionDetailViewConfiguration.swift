//
//  PLCardTransactionDetailConfiguration.swift
//  Santander
//
//  Created by Alvaro Royo on 30/9/21.
//

import Foundation
import Cards
import Models
import Commons
import UI

struct PLCardTransactionDetailViewConfiguration: CardTransactionDetailViewConfigurationProtocol {
    var showAmountBackground: Bool { false }
    
    func getShareable(from: CardTransactionEntity) -> String? {
        CardTransactionDetailStringBuilder()
            .add(description: from.dto.description)
            .add(amount: formattedAmount(amount: from.amount))
            .add(operationDate: NSAttributedString(string: dateFrom(dateStr: from.dto.postedDate ?? "") ?? ""))
            .add(status: localized((from.dto.state ?? .none).title))
            .add(bookingDate: dateFrom(dateStr: from.dto.sourceDate ?? ""))
            .add(recipient: from.dto.recipient)
            .add(accountNumber: accountNumber(str: from.dto.cardAccountNumber ?? ""))
            .add(operationType: from.dto.operationType?.capitalized)
            .build()
    }
    
    private func formattedAmount(amount: AmountEntity?) -> NSAttributedString? {
        guard let amount = amount else { return nil }
        let font = UIFont.santander(family: .text, type: .bold, size: 32)
        let moneyDecorator = MoneyDecorator(amount, font: font)
        return moneyDecorator.getFormatedCurrency()
    }
    
    private func dateFrom(dateStr: String) -> String? {
        let date =  dateFromString(input: dateStr, inputFormat: .yyyyMMdd)
        let dateStr = dateToString(date: date, outputFormat: .dd_MMM_yyyy) ?? ""
        return dateStr
    }
    
    private func accountNumber(str: String) -> String {
        var str = str
        str.insert(" ", at: str.index(str.startIndex, offsetBy: 4))
        str.insert(" ", at: str.index(str.startIndex, offsetBy: 9))
        str.insert(" ", at: str.index(str.startIndex, offsetBy: 12))
        return str
    }
    
    func getConfiguration(from: CardTransactionEntity) -> [CardTransactionDetailViewConfiguration] {
        var viewConfigurations = [CardTransactionDetailViewConfiguration]()
        // Obtain all details columns
        var filledDetailViews = [CardTransactionDetailView]()
        if let date = from.dto.sourceDate, let sourceDate = dateFrom(dateStr: date) {
            filledDetailViews.append(CardTransactionDetailView(title: localized("transaction_label_operationDate"), value: sourceDate))
        }
        if let status = from.dto.state, !status.hidden {
            filledDetailViews.append(CardTransactionDetailView(title: localized("transaction_label_statusDetail"), value: localized(status.title)))
        }
        if let date = from.dto.postedDate, let postedDate = dateFrom(dateStr: date) {
            filledDetailViews.append(CardTransactionDetailView(title: localized("transaction_label_annotationDate"), value: postedDate))
        }
        if let recipent = from.dto.recipient {
            filledDetailViews.append(CardTransactionDetailView(title: localized("transaction_label_recipient"), value: recipent))
        }
        // Create first row if there are enought details columns
        if filledDetailViews.count > 0 {
            viewConfigurations.append(CardTransactionDetailViewConfiguration(left: getConfigurationAtPosition(0, from: filledDetailViews), right: getConfigurationAtPosition(1, from: filledDetailViews)))
        }
        // Create second row if there are enought details columns
        if filledDetailViews.count > 2 {
            viewConfigurations.append(CardTransactionDetailViewConfiguration(left: getConfigurationAtPosition(2, from: filledDetailViews), right: getConfigurationAtPosition(3, from: filledDetailViews)))
        }
        if let cardAccountNumber = from.dto.cardAccountNumber {
            viewConfigurations.append(CardTransactionDetailViewConfiguration(left: CardTransactionDetailView(title: localized("transaction_label_cardAccountNumber"), value: accountNumber(str: cardAccountNumber)), right: nil))
        }
        if let operationType = from.dto.operationType?.capitalized {
            viewConfigurations.append(CardTransactionDetailViewConfiguration(left: CardTransactionDetailView(title: localized("transaction_label_operationType"), value: operationType), right: nil))
        }
        return viewConfigurations
    }
    
    private func getConfigurationAtPosition(_ position: Int, from array: [CardTransactionDetailView]) -> CardTransactionDetailView? {
        if array.count > position {
            return array[position]
        }
        return nil
    }
}

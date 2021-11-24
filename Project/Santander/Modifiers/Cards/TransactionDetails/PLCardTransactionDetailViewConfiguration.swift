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
        let postedDate = dateFrom(dateStr: from.dto.postedDate ?? "") ?? ""
        let row1Left = CardTransactionDetailView(title: localized("transaction_label_operationDate"), value: postedDate)
        let status = from.dto.state ?? .none
        let row1Right = status.hidden ? nil : CardTransactionDetailView(title: localized("transaction_label_statusDetail"), value: localized(status.title))
        let row1 = CardTransactionDetailViewConfiguration(left: row1Left,
                                                          right: row1Right)
        viewConfigurations.append(row1)
        let row2Date = dateFrom(dateStr: from.dto.sourceDate ?? "") ?? ""
        let row2Left = CardTransactionDetailView(title: localized("transaction_label_annotationDate"), value: row2Date)
        let row2Right = CardTransactionDetailView(title: localized("transaction_label_recipient"), value: from.dto.recipient ?? "")
        let row2 = CardTransactionDetailViewConfiguration(left: row2Left,
                                                          right: row2Right)
        viewConfigurations.append(row2)
        let accountNumberString = accountNumber(str: from.dto.cardAccountNumber ?? "")
        let row3Left = CardTransactionDetailView(title: localized("transaction_label_cardAccountNumber"), value: accountNumberString)
        let row3 = CardTransactionDetailViewConfiguration(left: row3Left,
                                                          right: nil)
        viewConfigurations.append(row3)
        let row4Left = CardTransactionDetailView(title: localized("transaction_label_operationType"), value: from.dto.operationType?.capitalized ?? "")
        let row4 = CardTransactionDetailViewConfiguration(left: row4Left,
                                                          right: nil)
        viewConfigurations.append(row4)
        return viewConfigurations
    }
}

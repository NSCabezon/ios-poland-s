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
        
        var row1 = CardTransactionDetailViewConfiguration()
        let postedDate = dateFrom(dateStr: from.dto.postedDate ?? "") ?? ""
        row1.left = .init(title: localized("transaction_label_operationDate"), value: postedDate)
        let status = from.dto.state ?? .none
        let hidden = status.hidden
        row1.right = hidden ? nil : .init(title: localized("transaction_label_statusDetail"), value: localized(status.title))
        viewConfigurations.append(row1)
        
        var row2 = CardTransactionDetailViewConfiguration()
        let row2Date = dateFrom(dateStr: from.dto.sourceDate ?? "") ?? ""
        row2.left = .init(title: localized("transaction_label_annotationDate"), value: row2Date)
        row2.right = .init(title: localized("transaction_label_recipient"), value: from.dto.recipient ?? "")
        viewConfigurations.append(row2)
        
        var row3 = CardTransactionDetailViewConfiguration()
        let accountNumberString = accountNumber(str: from.dto.cardAccountNumber ?? "")
        row3.left = .init(title: localized("transaction_label_cardAccountNumber"), value: accountNumberString)
        viewConfigurations.append(row3)
        
        var row4 = CardTransactionDetailViewConfiguration()
        row4.left = .init(title: localized("transaction_label_operationType"), value: from.dto.operationType?.capitalized ?? "")
        viewConfigurations.append(row4)
        
        return viewConfigurations
    }
}

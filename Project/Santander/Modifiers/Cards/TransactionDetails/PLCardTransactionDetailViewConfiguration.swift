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

struct PLCardTransactionDetailViewConfiguration : CardTransactionDetailViewConfigurationProtocol {
    var showAmountBackground: Bool { false }
    
    func getShareable(from: CardTransactionEntity) -> String? {
        CardTransactionDetailStringBuilder()
            .add(description: from.dto.description)
            .add(amount: formattedAmount(amount: from.amount))
            .add(operationDate: dateAndHour(dateStr: from.dto.postedDate ?? ""))
            .add(status: localized((from.dto.state ?? .none).title))
            .add(bookingDate: dateToString(date: from.dto.operationDate, outputFormat: .dd_MMM_yyyy))
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
    
    private func dateAndHour(dateStr: String) -> NSAttributedString? {
        let date =  dateFromString(input: dateStr, inputFormat: .yyyy_MM_ddHHmmss)
        let dateStr = dateToString(date: date, outputFormat: .dd_MMM_yyyy_point_HHmm) ?? ""
        let attributtedString = NSMutableAttributedString(string: dateStr)
        attributtedString.addAttributes([.font: UIFont.santanderTextRegular(size: 11)], range: NSRange(location: 14, length: 5))
        return attributtedString
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
        let attributtedString = dateAndHour(dateStr: from.dto.postedDate ?? "") ?? .init()
        row1.left = .init(title: localized("transaction_label_operationDate"), value: attributtedString)
        let status = from.dto.state ?? .none
        let hidden = status.hidden
        row1.right = hidden ? nil : .init(title: localized("transaction_label_statusDetail"), value: localized(status.title))
        viewConfigurations.append(row1)
        
        var row2 = CardTransactionDetailViewConfiguration()
        let row2Date = dateToString(date: from.dto.operationDate, outputFormat: .dd_MMM_yyyy) ?? ""
        row2.left = .init(title: localized("transaction_label_annotationDate"), value: row2Date)
        row2.right = .init(title: localized("transaction_label_recipient"), value: from.dto.recipient ?? "")
        viewConfigurations.append(row2)
        
        var row3 = CardTransactionDetailViewConfiguration()
        let accountNumber = accountNumber(str: from.dto.cardAccountNumber ?? "")
        row3.left = .init(title: localized("transaction_label_cardAccountNumber"), value: accountNumber)
        viewConfigurations.append(row3)
        
        var row4 = CardTransactionDetailViewConfiguration()
        row4.left = .init(title: localized("transaction_label_operationType"), value: from.dto.operationType?.capitalized ?? "")
        viewConfigurations.append(row4)
        
        return viewConfigurations
    }
}

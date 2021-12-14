//
//  CharityTransferViewModel.swift
//  CharityTransfer
//
//  Created by 187830 on 08/11/2021.
//

import Commons
import PLCommons
import PLUI
import Operative
import Models
import SANLegacyLibrary

struct CharityTransferConfirmationViewModel {
    
    private var transfer: CharityTransferModel
    
    init(transfer: CharityTransferModel) {
        self.transfer = transfer
    }
    
    var title: String {
        transfer.title ?? localized("pl_foundtrans_text_titleTransFound")
    }
    
    var dateString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        return dateFormatter.string(from: transfer.date ?? Date())
    }
    
    var recipientName: String {
        transfer.title ?? localized("pl_foundtrans_text_RecipFoudSant")
    }
    
    var transferType: String {
        localized("#pl_charity_label_transactionType")
    }
    
    var amountTitle: String {
        localized("pl_foundtrans_text_total")
    }
    
    func amountValueString(withAmountSize size: CGFloat) -> NSAttributedString {
        let moneyDecorator = MoneyDecorator(
            AmountEntity(value: amount, currency: .złoty),
            font: .santander(family: .text, type: .bold, size: size)
        )
        let amount =  moneyDecorator.getFormatedCurrency() ?? NSAttributedString(string: "\(amount)")
        return amount
    }
    
    var accountName: String {
        transfer.account.name
    }
    
    var accountNumber: String {
        IBANFormatter.format(iban: transfer.account.number)
    }
    
    var account: AccountForDebit {
        transfer.account
    }
    
    var amount: Decimal {
        transfer.amount ?? 0
    }
    
    var date: Date? {
        transfer.date
    }
    
    var items: [OperativeSummaryStandardBodyItemViewModel] {
        let items: [OperativeSummaryStandardBodyItemViewModel] = [
            .init(title: localized("summary_item_amount"),
                  subTitle: amountValueString(withAmountSize: 32),
                  info: title),
            .init(title: localized("pl_foundtrans_label_summ_accountNumb"),
                  subTitle: accountName,
                  info: accountNumber),
            .init(title: localized("pl_foundtrans_label_recipientTransfer"),
                  subTitle: recipientName),
            .init(title: localized("pl_foundtrans_label_transType"),
                  subTitle: transferType),
            .init(title: localized("pl_foundtrans_label_date"),
                  subTitle: dateString)]
        return items
    }
}

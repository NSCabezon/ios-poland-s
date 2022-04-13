import CoreFoundationLib
import PLCommons
import PLUI
import Operative
import SANLegacyLibrary
import UI
import UIKit

struct ZusSmeTransferConfirmationViewModel {
    private var transfer: ZusSmeTransferModel
    
    init(transfer: ZusSmeTransferModel) {
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
        transfer.recipientName ?? localized("pl_foundtrans_text_RecipFoudSant")
    }
    
    var recipientAccountNumber: String {
        IBANFormatter.format(iban: transfer.recipientAccountNumber)
    }
    
    var transferType: String {
        localized("pl_zusTransfer_text_transactionTypeText")
    }

    var accountName: String {
        transfer.account.name
    }
    
    var accountDetails: NSAttributedString {
        let attributedStringAccountNumber = AttributedStringBuilder(
            string: IBANFormatter.format(iban: transfer.account.number),
            properties: attributedAccountNumber
        ).build()
        let attributedStringTitleVat = AttributedStringBuilder(
            string: ["\n",localized("pl_zusTransfer_text_linkedAcc")].joined(),
            properties: attributedTitleVat
        ).build()
        let accountVatName = transfer.accountVat?.name ?? ""
        let attributedStringSubtitleVat = AttributedStringBuilder(
            string: ["\n",accountVatName].joined(),
            properties: attributedSubtitleVat
        ).build()
        let attributedStringAccountVatNumber = AttributedStringBuilder(
            string: ["\n",IBANFormatter.format(iban: transfer.accountVat?.number)].joined(),
            properties: attributedAccountVatNumber
        ).build()

        let attributedAccountDetails = NSMutableAttributedString()
        [
            attributedStringAccountNumber,
            attributedStringTitleVat,
            attributedStringSubtitleVat,
            attributedStringAccountVatNumber
        ].forEach {
            attributedAccountDetails.append($0)
        }
        return attributedAccountDetails
    }
    
    var account: AccountForDebit {
        transfer.account
    }
    
    var amount: Decimal {
        transfer.amount
    }
    
    var date: Date? {
        transfer.date
    }
    
    var items: [OperativeSummaryStandardBodyItemViewModel] {
        let items: [OperativeSummaryStandardBodyItemViewModel] = [
            .init(title: localized("pl_zusTransfer_text_Amount"),
                  subTitle: amountValueString(withAmountSize: 32),
                  info: title),
            .init(title: localized("pl_zusTransfer_text_account"),
                  subTitle: accountName,
                  info: accountDetails),
            .init(title: localized("pl_zusTransfer_text_receipent"),
                  subTitle: recipientName,
                  info: recipientAccountNumber),
            .init(title: localized("pl_zusTransfer_text_transactionType"),
                  subTitle: transferType),
            .init(title: localized("pl_zusTransfer_text_date"),
                  subTitle: dateString)]
        return items
    }
    
    func amountValueString(withAmountSize size: CGFloat) -> NSAttributedString {
        PLAmountFormatter.amountString(
            amount: amount,
            currency: .złoty,
            withAmountSize: size
        )
    }
}

private extension ZusSmeTransferConfirmationViewModel {
    
    var attributedAccountNumber: [NSAttributedString.Key: NSObject] {
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 6
        return [
            NSAttributedString.Key.foregroundColor: UIColor.lisboaGray,
            NSAttributedString.Key.font: UIFont.santander(family: .text, type: .italic, size: 14),
            NSAttributedString.Key.paragraphStyle: style
        ]
    }
    
    var attributedTitleVat: [NSAttributedString.Key: NSObject] {
        [
            NSAttributedString.Key.foregroundColor: UIColor.grafite,
            NSAttributedString.Key.font: UIFont.santander(family: .text, type: .regular, size: 13)
        ]
    }
    
    var attributedSubtitleVat: [NSAttributedString.Key: NSObject] {
        [
            NSAttributedString.Key.foregroundColor: UIColor.lisboaGray,
            NSAttributedString.Key.font: UIFont.santander(family: .text, type: .bold, size: 14)
        ]
    }
    
    var attributedAccountVatNumber: [NSAttributedString.Key: NSObject] {
        [
            NSAttributedString.Key.foregroundColor: UIColor.lisboaGray,
            NSAttributedString.Key.font: UIFont.santander(family: .text, type: .italic, size: 14)
        ]
    }
}

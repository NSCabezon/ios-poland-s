import CoreFoundationLib
import PLCommons
import PLUI
import Operative
import CoreFoundationLib
import SANLegacyLibrary

struct ZusTransferConfirmationViewModel {
    
    private var transfer: ZusTransferModel
    
    init(transfer: ZusTransferModel) {
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
    
    func amountValueString(withAmountSize size: CGFloat) -> NSAttributedString {
        PLAmountFormatter.amountString(
            amount: amount,
            currency: .złoty,
            withAmountSize: size
        )
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
                  info: accountNumber),
            .init(title: localized("pl_zusTransfer_text_receipent"),
                  subTitle: recipientName,
                  info: recipientAccountNumber),
            .init(title: localized("pl_zusTransfer_text_transactionType"),
                  subTitle: transferType),
            .init(title: localized("pl_zusTransfer_text_date"),
                  subTitle: dateString)]
        return items
    }
}

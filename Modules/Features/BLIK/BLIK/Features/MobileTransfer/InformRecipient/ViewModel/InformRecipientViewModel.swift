import Commons
import UI

struct InformRecipientViewModel {
    
    private let summary: MobileTransferSummary
    
    init(summary: MobileTransferSummary) {
        self.summary = summary
    }
    
    var header: String {
        "#Cześć, \(summary.accountHolder) wysłał przelew z takimi informacjami:"
    }
    
    var listViewModel: [InformRecipientInfoItem.ViewModel] {
        let icon: UIImage? = summary.transferType == .INTERNAL ? Assets.image(named: "icnSantanderPg") : nil
        let amount = AmountFormatter.amountString(amount: summary.amount, currency: summary.currency, withAmountSize: 32)
        let formattedAmount = AttributedStringBuilder(attributedString: amount)
            .addLineHeightMultiple(0.85).build()
    
        return [
            .init(header: localized("pl_blik_text_amountTransfer"),
                  value: formattedAmount),
            .init(header: "#Tytułem",
                  value: NSAttributedString(string: summary.title)),
            .init(header: localized("pl_blik_label_accountTransfter"),
                  value: NSAttributedString(string: summary.accountNumber),
                  icon: icon),
            .init(header: localized("pl_blik_label_recipientTransfer"),
                  value: NSAttributedString(string: "\(summary.recipientName)\n\(summary.recipientNumber)")),
            .init(header: localized("summary_item_transactionDate"),
                  value: NSAttributedString(string: summary.dateString),
                  hideSeparator: true)
        ]
    }

}

import CoreFoundationLib
import PLCommons
import UI

struct InformRecipientViewModel {
    
    private let summary: MobileTransferSummary
    
    init(summary: MobileTransferSummary) {
        self.summary = summary
    }
    
    var header: String {
        localized("pl_blikP2P_text_infoAboutTransfer", [StringPlaceholder(.value, summary.accountHolder)]).text
    }
    
    var listViewModel: [InformRecipientInfoItem.ViewModel] {
        let icon: UIImage? = summary.transferType == .INTERNAL ? Assets.image(named: "icnSantanderPg") : nil
        let amount = PLAmountFormatter.amountString(amount: summary.amount, currency: summary.currency, withAmountSize: 32)
        let formattedAmount = AttributedStringBuilder(attributedString: amount)
            .addLineHeightMultiple(0.85).build()
        return [
            .init(header: localized("pl_blikP2P_text_amount"),
                  value: formattedAmount),
            .init(header: localized("pl_blikP2P_text_title"),
                  value: NSAttributedString(string: summary.title)),
            .init(header: localized("pl_blikP2P_text_accYouPayFrom"),
                  value: NSAttributedString(string: summary.accountNumber),
                  icon: icon),
            .init(header: localized("pl_blikP2P_text_recepient"),
                  value: NSAttributedString(string: "\(summary.recipientName)\n\(summary.recipientNumber)")),
            .init(header: localized("pl_blikP2P_text_date"),
                  value: NSAttributedString(string: summary.dateString),
                  hideSeparator: true)
        ]
    }

}

import CoreFoundationLib
import UI

class InformRecipientHandler {

    func shareSummary(_ summary: MobileTransferSummary, in viewController: UIViewController) {
        let summaryView = InformRecipientView(viewModel: .init(summary: summary))
        
        summaryView.view.layoutIfNeeded()
        let shareView = SharedHandler()
        shareView.shareByImage(summaryView,
                               in: viewController,
                               viewToShare: summaryView.sharedContainer,
                               onlyWhatsApp: false)
    }

}

import Foundation
import UI
import PLUI
import CoreFoundationLib
import MessageUI

class NoBlikContactDialog: NSObject {

    func showDialog(in view: UIViewController) {
        let title: LocalizedStylableText = localized("pl_blik_alert_title_recipBase")
        let info: LocalizedStylableText = localized("pl_blik_alert_text_recipBase")
        
        let items: [LisboaDialogItem] = [
            .margin(26),
            .image(.init(image: PLAssets.image(named: "grayInfoIcon"), size: (51, 51))),
            .margin(10),
            .styledText(
                .init(text: title,
                      font: .santander(family: .headline, type: .bold, size: 28),
                      color: .lisboaGray,
                      alignament: .center,
                      margins: (left: 24.0, right: 24.0))
            ),
            .margin(14),
            .styledText(
                .init(text: info,
                      font: .santander(family: .micro, type: .regular, size: 16),
                      color: .lisboaGray,
                      alignament: .center,
                      margins: (left: 32.0, right: 32.0))
            ),
            .margin(22),
            .verticalAction(.init(title: localized("pl_blik_alert_button_recipBase"),
                                  type: .white,
                                  margins: (left: 16, right: 16),
                                  action: {[weak self] in
                                    self?.openShareActivity(in: view)
                                  })),
            .margin(22),
            .verticalAction(.init(title: localized("generic_link_ok"),
                                  type: .red,
                                  margins: (left: 16, right: 16),
                                  isCancelAction: true,
                                  action: {})),
            .margin(16.0)
        ]
        
        let dialog = LisboaDialog.init(items: items, closeButtonAvailable: false)
        dialog.showIn(view)
    }
    
    private func openShareActivity(in viewController: UIViewController) {
        let message: String = localized("pl_blik_text_messageGeneric")
        let items = [message]
        
        let activityController = UIActivityViewController(activityItems: items, applicationActivities: nil)
        
        viewController.present(activityController, animated: true, completion: nil)
    }
}

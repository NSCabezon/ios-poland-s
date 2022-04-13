import Foundation
import CoreFoundationLib
import UI
import PLUI

final class CameraPermissionsDeniedDialogBuilder {
    func buildDialog(closeAction: @escaping () -> Void) -> LisboaDialog {
        let title: LocalizedStylableText = localized("pl_scanAndPay_popupTitle_accessNeeded")
        let info: LocalizedStylableText = localized("pl_scanAndPay_popupText_accessNeeded")
        
        let items: [LisboaDialogItem] = [
            .closeAction({
                closeAction()
            }),
            .image(.init(image: PLAssets.image(named: "grayInfoIcon"),
                         size: (50, 50))),
            .margin(6),
            .styledText(
                .init(text: title,
                      font: .santander(family: .headline, type: .bold, size: 28),
                      color: .lisboaGray,
                      alignament: .center,
                      margins: (left: 28.0, right: 28.0))
            ),
            .margin(18),
            .styledText(
                .init(text: info,
                      font: .santander(family: .micro, type: .regular, size: 16),
                      color: .lisboaGray,
                      alignament: .center,
                      margins: (left: 28.0, right: 28.0))
            ),
            .margin(32),
            .verticalAction(
                VerticalLisboaDialogAction(
                    title: localized("pl_scanAndPay_button_goToSettings"),
                    type: .red, margins: (left: 16, right: 16),
                    isCancelAction: false,
                    action: {
                        guard let url = URL(string:UIApplication.openSettingsURLString) else { return }
                        if UIApplication.shared.canOpenURL(url) {
                            UIApplication.shared.open(url, options: [:], completionHandler: nil)
                        }
                    }
                )
            ),
            .margin(16.0),
        ]
        
        return LisboaDialog(items: items, closeButtonAvailable: true)
    }
}

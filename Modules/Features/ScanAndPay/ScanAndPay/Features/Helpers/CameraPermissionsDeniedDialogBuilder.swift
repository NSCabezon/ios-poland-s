import Foundation
import CoreFoundationLib
import UI
import PLUI

final class CameraPermissionsDeniedDialogBuilder {
    func buildDialog(closeAction: @escaping () -> Void) -> LisboaDialog {
        #warning("change text and images")
        let title: LocalizedStylableText = localized("#Dostęp do galerii zdjęć i aparatu")
        let info: LocalizedStylableText = localized("Aby korzystać z funkcji Skanuj i płać, zezwól aplikacji na dostęp do galerii zdjęć i aparatu.")
        let infoBold: LocalizedStylableText = localized("Po kliknięciu przycisku „Przejdź do ustawień” przeniesiemy Cię do ustawień Twojego telefonu. ")
        
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
            .margin(18),
            .styledText(
                .init(text: infoBold,
                      font: .santander(family: .micro, type: .bold, size: 16),
                      color: .lisboaGray,
                      alignament: .center,
                      margins: (left: 28.0, right: 28.0))
            ),
            .margin(32),
            .verticalAction(
                VerticalLisboaDialogAction(
                    title: localized("#Przejdź do ustawień"),
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

import Foundation
import Contacts
import UI
import PLUI
import Commons

protocol ContactPermissionAuthorizatorProtocol {
    func authorizeContactPermission(in view: UIViewController,
                                    completion: @escaping () -> Void)
}

class ContactPermissionAuthorizator: ContactPermissionAuthorizatorProtocol {
    
    func authorizeContactPermission(in view: UIViewController, completion: @escaping () -> Void) {
        switch CNContactStore.authorizationStatus(for: .contacts) {
        case .authorized:
            completion()
        case .notDetermined:
            CNContactStore().requestAccess(for: .contacts) {access, error in
                guard access else {
                    return
                }

                DispatchQueue.main.async {
                    completion()
                }
            }
        case .denied, .restricted:
            showDialog(in: view)
        @unknown default:
            fatalError()
        }
    }
}

private extension ContactPermissionAuthorizator {
    func showDialog(in view: UIViewController) {
        let title: LocalizedStylableText = localized("#Nadaj potrzebne uprawnienia")
        let info: LocalizedStylableText = localized("#Aby wybrać odbiorcę przelewu z listy kontaktów, zezwól aplikacji na dostęp do nich.")
        let boldInfo: LocalizedStylableText = localized("#Przejdź do ustawień swojego telefonu i nadaj potrzebne uprawnienia.")
        
        let items: [LisboaDialogItem] = [
            .image(.init(image: PLAssets.image(named: "grayInfoIcon"), size: (51, 51))),
            .margin(10),
            .styledText(
                .init(text: title,
                      font: .santander(family: .headline, type: .bold, size: 28),
                      color: .lisboaGray,
                      alignament: .center,
                      margins: (left: 24.0, right: 24.0))
            ),
            .margin(8),
            .styledText(
                .init(text: info,
                      font: .santander(family: .micro, type: .regular, size: 16),
                      color: .lisboaGray,
                      alignament: .center,
                      margins: (left: 32.0, right: 32.0))
            ),
            .margin(24),
            .styledText(
                .init(text: boldInfo,
                      font: .santander(family: .micro, type: .bold, size: 16),
                      color: .lisboaGray,
                      alignament: .center,
                      margins: (left: 32.0, right: 32.0))
            ),
            .margin(24),
            .verticalAction(VerticalLisboaDialogAction(title: localized("#Przejdź do ustawień"), type: .red, margins: (left: 16, right: 16), action: {[weak self] in
                self?.goToSettings()
            })),
            .margin(16.0)
        ]
        
        let dialog = LisboaDialog.init(items: items, closeButtonAvailable: true)
        dialog.showIn(view)
    }
    
    func goToSettings() {
        guard let url = URL(string:UIApplication.openSettingsURLString) else { return }
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}

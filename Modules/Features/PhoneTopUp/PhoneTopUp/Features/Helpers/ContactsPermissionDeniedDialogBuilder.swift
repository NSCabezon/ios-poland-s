//
//  ContactsPermissionDeniedDialogBuilder.swift
//  PhoneTopUp
//
//  Created by 188216 on 05/01/2022.
//

import CoreFoundationLib
import Foundation
import UI
import PLUI

final class ContactsPermissionDeniedDialogBuilder {
    func buildDialog() -> LisboaDialog {
        let title: LocalizedStylableText = localized("pl_topup_alert_title_phonebookAccess")
        let info: LocalizedStylableText = localized("pl_topup_alert_text_phonebookAccess")
        
        let items: [LisboaDialogItem] = [
            .image(.init(image: Images.PhoneContacts.redInfoIcon, size: (50, 50))),
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
                    title: localized("pl_topup_button_phoneSettings"),
                    type: .red, margins: (left: 16, right: 16),
                    action: {
                        guard let url = URL(string:UIApplication.openSettingsURLString) else { return }
                        if UIApplication.shared.canOpenURL(url) {
                            UIApplication.shared.open(url, options: [:], completionHandler: nil)
                        }
                    }
                )
            ),
            .margin(16.0)
        ]
        
        return LisboaDialog(items: items, closeButtonAvailable: true)
    }
}

//
//  HelpCenterDialogFactory.swift
//  PLHelpCenter
//
//  Created by 186490 on 18/08/2021.
//

import Foundation
import CoreFoundationLib
import UI

final class HelpCenterDialogFactory {
    static func makeErrorDialog() -> LisboaDialog {
        let title: LocalizedStylableText = localized("generic_title_alertError")
        let body: LocalizedStylableText = localized("pl_helpdesk_alert_connectionFailedText")
        let absoluteMargin: (left: CGFloat, right: CGFloat) = (left: 24.0, right: 24.0)
        let onCancel: () -> Void = {}
        let components: [LisboaDialogItem] = [
            .margin(8.0),
            .styledText(
                LisboaDialogTextItem(
                    text: title,
                    font: .santander(family: .text, type: .regular, size: 29),
                    color: .black,
                    alignament: .center,
                    margins: absoluteMargin)),
            .margin(12.0),
            .styledText(
                LisboaDialogTextItem(
                    text: body,
                    font: .santander(family: .text, type: .light, size: 16),
                    color: .lisboaGray,
                    alignament: .center,
                    margins: absoluteMargin)),
            .margin(24.0),
            .verticalAction(VerticalLisboaDialogAction(title: localized("generic_button_understand"), type: .red, margins: (left: 16, right: 16), action: onCancel)),
            .margin(12.0)
        ]
        return LisboaDialog(items: components, closeButtonAvailable: false)
    }
    
    static func makeLoginInfoDialog(loginAction: (() -> Void)?) -> LisboaDialog {
         let loginAction = LisboaDialogAction(title: localized("pl_helpdesk_alert_loginButton"), type: .red, margins: (left: 16.0, right: 8.0)) {
             loginAction?()
         }
         let cancelAction = LisboaDialogAction(title: localized("generic_link_cancel"), type: .white, margins: (left: 16.0, right: 8.0)) { }
         let body: LocalizedStylableText = LocalizedStylableText(text: localized("pl_accountServices_popup_logInToContinue"), styles: nil)
         let absoluteMargin: (left: CGFloat, right: CGFloat) = (left: 24.0, right: 24.0)
         let components: [LisboaDialogItem] = [
             .margin(8.0),
             .styledText(
                 LisboaDialogTextItem(
                     text: LocalizedStylableText.empty,
                     font: .santander(family: .text, type: .regular, size: 29),
                     color: .black,
                     alignament: .center,
                     margins: absoluteMargin)),
             .margin(12.0),
             .styledText(
                 LisboaDialogTextItem(
                     text: body,
                     font: .santander(family: .text, type: .light, size: 16),
                     color: .lisboaGray,
                     alignament: .center,
                     margins: absoluteMargin)),
             .margin(24.0),
             .horizontalActions(HorizontalLisboaDialogActions(left: cancelAction, right: loginAction)),
             .margin(12.0)
         ]
         return LisboaDialog(items: components, closeButtonAvailable: false)
     }
}

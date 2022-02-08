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
}

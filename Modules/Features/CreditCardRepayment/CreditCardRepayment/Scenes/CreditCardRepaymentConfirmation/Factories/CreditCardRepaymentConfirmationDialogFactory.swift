//
//  CreditCardRepaymentConfirmationDialogFactory.swift
//  CreditCardRepayment
//
//  Created by 186490 on 06/07/2021.
//

import Commons
import Operative
import UI

final class CreditCardRepaymentConfirmationDialogFactory {
    static func makeErrorDialog() -> LisboaDialog {
        let title: LocalizedStylableText = localized("pl_creditCard_alert_repFailTitle")
        let body: LocalizedStylableText = localized("pl_creditCard_alert_repFailText")
        let absoluteMargin: (left: CGFloat, right: CGFloat) = (left: 24.0, right: 24.0)
        let onCancel: () -> Void = {}
        let components: [LisboaDialogItem] = [
            .image(LisboaDialogImageViewItem(image: UIImage(named: "warningSymbol", in: .module, compatibleWith: nil), size: (left: 64, right: 64))),
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
        return LisboaDialog(items: components, closeButtonAvailable: true)
    }
}

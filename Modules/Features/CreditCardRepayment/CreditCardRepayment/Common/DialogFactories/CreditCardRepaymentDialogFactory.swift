//
//  CreditCardRepaymentDialogFactory.swift
//  CreditCardRepayment
//
//  Created by 186484 on 27/07/2021.
//

import CoreFoundationLib
import UI

final class CreditCardRepaymentDialogFactory {
    static func makeNoCardsErrorDialog() -> LisboaDialog {
        let title: LocalizedStylableText = localized("pl_creditCard_alert_cannotLoadTitle")
        let body: LocalizedStylableText = localized("pl_creditCard_alert_cannotLoadText")
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
            .verticalAction(VerticalLisboaDialogAction(title: localized("generic_link_yes"), type: .red, margins: (left: 16, right: 16), action: onCancel)),
            .margin(12.0)
        ]
        return LisboaDialog(items: components, closeButtonAvailable: true)
    }
}


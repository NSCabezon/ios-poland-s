//
//  CreditCardRepaymentDetailsDialogFactory.swift
//  CreditCardRepayment
//
//  Created by 186484 on 06/07/2021.
//

import CoreFoundationLib
import UI

final class CreditCardRepaymentDetailsDialogFactory {
    static func makeMinimumAmountDialog() -> LisboaDialog {
        let title: LocalizedStylableText = localized("pl_creditCard_alert_repMinAmountTitle")
        let body: LocalizedStylableText = localized("pl_creditCard_alert_repMinAmountText")
        let absoluteMargin: (left: CGFloat, right: CGFloat) = (left: 24.0, right: 24.0)
        let onCancel: () -> Void = { }
        let components: [LisboaDialogItem] = [
            .margin(11.0),
            .styledText(
                LisboaDialogTextItem(
                    text: title,
                    font: .santander(family: .text, type: .regular, size: 29),
                    color: .black,
                    alignament: .center,
                    margins: absoluteMargin)),
            .margin(5.0),
            .styledText(
                LisboaDialogTextItem(
                    text: body,
                    font: .santander(family: .text, type: .light, size: 16),
                    color: .lisboaGray,
                    alignament: .center,
                    margins: absoluteMargin)),
            .margin(26.0),
            .verticalAction(VerticalLisboaDialogAction(title: localized("generic_link_ok"), type: .red, margins: (left: 16, right: 16), action: onCancel)),
            .margin(12.0)
            
        ]
        return LisboaDialog(items: components, closeButtonAvailable: true)
    }
    
    static func makeConfirmAbandonChangesDialog(onAccept: @escaping () -> Void) -> LisboaDialog {
        let title = LisboaDialogTextItem(text: localized("pl_creditCard_label_repPrev"),
                                         font: .santander(family: .text, type: .regular, size: 29),
                                         color: .black,
                                         alignament: .center,
                                         margins: (left: 16.0, right: 16.0))
        
        let body = LisboaDialogTextItem(text: localized("pl_creditCard_text_repPrev"),
                                        font: .santander(family: .text, type: .light, size: 16),
                                        color: .lisboaGray,
                                        alignament: .center,
                                        margins: (left: 16.0, right: 16.0))
        
        let cancelButton = LisboaDialogAction(title: localized("generic_link_no"),
                                              type: .white,
                                              margins: (left: 16.0, right: 16.0),
                                              action: {})
        
        let okButton = LisboaDialogAction(title: localized("generic_link_yes"),
                                          type: .red,
                                          margins: (left: 16.0, right: 16.0),
                                          action: onAccept)
        return LisboaDialog(items: [
            .margin(20.0),
            .styledText(title),
            .margin(13.0),
            .styledText(body),
            .margin(12.0),
            .horizontalActions(
                HorizontalLisboaDialogActions(
                    left: cancelButton,
                    right: okButton)
            )
        ], closeButtonAvailable: false)
    }
    
    static func makeCloseDialog(onAccept: @escaping () -> Void) -> LisboaDialog {
        let title = LisboaDialogTextItem(text: localized("pl_creditCard_alert_repQuitTitle"),
                                         font: .santander(family: .text, type: .regular, size: 29),
                                         color: .black,
                                         alignament: .center,
                                         margins: (left: 16.0, right: 16.0))
        
        let body = LisboaDialogTextItem(text: localized("pl_creditCard_alert_repQuitText"),
                                        font: .santander(family: .text, type: .light, size: 16),
                                        color: .lisboaGray,
                                        alignament: .center,
                                        margins: (left: 16.0, right: 16.0))
        
        let cancelButton = LisboaDialogAction(title: localized("generic_link_no"),
                                              type: .white,
                                              margins: (left: 16.0, right: 16.0),
                                              action: {})
        
        let okButton = LisboaDialogAction(title: localized("generic_link_yes"),
                                          type: .red,
                                          margins: (left: 16.0, right: 16.0),
                                          action: onAccept)
        return LisboaDialog(items: [
            .image(LisboaDialogImageViewItem(image: UIImage(named: "warningSymbol", in: .module, compatibleWith: nil), size: (left: 64, right: 64))),
            .margin(8.0),
            .styledText(title),
            .margin(13.0),
            .styledText(body),
            .margin(12.0),
            .horizontalActions(
                HorizontalLisboaDialogActions(
                    left: cancelButton,
                    right: okButton)
            )
        ], closeButtonAvailable: false)
    }
}

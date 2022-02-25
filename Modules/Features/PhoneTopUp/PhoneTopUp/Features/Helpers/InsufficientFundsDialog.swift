//
//  InsufficientFundsDialog.swift
//  PhoneTopUp
//
//  Created by 188216 on 17/02/2022.
//

import CoreFoundationLib
import Foundation
import UI
import PLUI

final class InsufficientFundsDialogBuilder {
    func buildDialog() -> LisboaDialog {
        #warning("todo: add translations when available")
        let title: LocalizedStylableText = localized("#Nie posiadasz wystarczającej ilości środków")
        let info: LocalizedStylableText = localized("#Wybierz mniejszą kwotę")
        
        let items: [LisboaDialogItem] = [
            .image(.init(image: Images.PhoneContacts.redInfoIcon, size: (50, 50))),
            .margin(12),
            .styledText(
                .init(text: title,
                      font: .santander(family: .headline, type: .bold, size: 28),
                      color: .lisboaGray,
                      alignament: .center,
                      margins: (left: 28.0, right: 28.0))
            ),
            .margin(16),
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
                    title: localized("generic_link_ok"),
                    type: .red, margins: (left: 16, right: 16),
                    action: {}
                )
            ),
            .margin(16.0)
        ]
        
        return LisboaDialog(items: items, closeButtonAvailable: true)
    }
}

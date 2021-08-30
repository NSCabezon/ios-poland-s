//
//  PLLoginCommonDialogs.swift
//  PLLogin
//
//  Created by Mario Rosales Maillo on 25/8/21.
//

import Foundation
import UI
import Commons

final class PLLoginCommonDialogs {
    
    static func presentCloseDialog(on viewController: UIViewController,
                        onCancel: @escaping () -> Void,
                        onAccept: @escaping () -> Void) {
        
        let absoluteMargin: (left: CGFloat, right: CGFloat) = (left: 19.0, right: 9.0)
        let components: [LisboaDialogItem] = [
            .image(LisboaDialogImageViewItem(image: Assets.image(named: "icnDanger"), size: (70, 70))),
            .styledText(
                LisboaDialogTextItem(
                    text: localized("pl_onboarding_alert_PINQuitTitle"),
                    font: .santander(family: .text, type: .bold, size: 28),
                    color: .lisboaGray,
                    alignament: .center,
                    margins: absoluteMargin)),
            .margin(12.0),
            .styledText(
                LisboaDialogTextItem(
                    text: localized("pl_onboarding_alert_PINQuitText"),
                    font: .santander(family: .text, type: .light, size: 16),
                    color: .lisboaGray,
                    alignament: .center,
                    margins: absoluteMargin)),
            .margin(24.0),
            .horizontalActions(
                HorizontalLisboaDialogActions(
                    left: LisboaDialogAction(title: localized("generic_link_no"),
                                             type: .white,
                                             margins: absoluteMargin,
                                             action: onCancel),
                    right: LisboaDialogAction(title: localized("generic_link_yes"),
                                              type: .red,
                                              margins: absoluteMargin,
                                              action: onAccept))),
            .margin(16.0)
        ]
        let builder = LisboaDialog(items: components, closeButtonAvailable: true)
        builder.showIn(viewController)
    }
}

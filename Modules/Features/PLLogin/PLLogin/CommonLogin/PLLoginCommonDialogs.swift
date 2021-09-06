//
//  PLLoginCommonDialogs.swift
//  PLLogin
//
//  Created by Mario Rosales Maillo on 25/8/21.
//

import Foundation
import UI
import PLUI
import Commons

final class PLLoginCommonDialogs {
    
    enum Constants {
        static let absoluteMargin: (left: CGFloat, right: CGFloat) = (left: 19.0, right: 9.0)
    }

    static func presentGenericDialogWithText(on viewController: UIViewController, textKey: String, completion: (() -> Void)? = nil) {
        let absoluteMargin: (left: CGFloat, right: CGFloat) = (left: 16.0, right: 16.0)
        let components: [LisboaDialogItem] = [
            .margin(16.0),
            .styledText(
                LisboaDialogTextItem(
                    text: localized(textKey),
                    font: .santander(family: .text, type: .regular, size: 16),
                    color: .lisboaGray,
                    alignament: .center,
                    margins: absoluteMargin)),
            .margin(24.0),
            .verticalAction(VerticalLisboaDialogAction(title: localized("generic_button_understand"),
                                                              type: .red,
                                                              margins: absoluteMargin,
                                                              action: completion ?? {} )),
            .margin(16.0)
        ]
        let builder = LisboaDialog(items: components, closeButtonAvailable: false)
        builder.showIn(viewController)
    }
    
    static func presentCloseDialog(on viewController: UIViewController,
                        onCancel: @escaping () -> Void,
                        onAccept: @escaping () -> Void) {
        
        let components: [LisboaDialogItem] = [
            .image(LisboaDialogImageViewItem(image: Assets.image(named: "icnDanger"), size: (70, 70))),
            .styledText(
                LisboaDialogTextItem(
                    text: localized("pl_onboarding_alert_PINQuitTitle"),
                    font: .santander(family: .text, type: .bold, size: 28),
                    color: .lisboaGray,
                    alignament: .center,
                    margins: Constants.absoluteMargin)),
            .margin(12.0),
            .styledText(
                LisboaDialogTextItem(
                    text: localized("pl_onboarding_alert_PINQuitText"),
                    font: .santander(family: .text, type: .light, size: 16),
                    color: .lisboaGray,
                    alignament: .center,
                    margins: Constants.absoluteMargin)),
            .margin(24.0),
            .horizontalActions(
                HorizontalLisboaDialogActions(
                    left: LisboaDialogAction(title: localized("generic_link_no"),
                                             type: .white,
                                             margins: Constants.absoluteMargin,
                                             action: onCancel),
                    right: LisboaDialogAction(title: localized("generic_link_yes"),
                                              type: .red,
                                              margins: Constants.absoluteMargin,
                                              action: onAccept))),
            .margin(16.0)
        ]
        let builder = LisboaDialog(items: components, closeButtonAvailable: true)
        builder.showIn(viewController)
    }
    
    static func presentDeprecatedVersionDialog(on viewController: UIViewController,
                                               onAccept: @escaping () -> Void) {
        let components: [LisboaDialogItem] = [
            .image(LisboaDialogImageViewItem(image: Assets.image(named: "icnSantanderBalance"), size: (56, 56))),
            .styledText(
                LisboaDialogTextItem(
                    text: localized("login_alert_title_updateYourAppSan"),
                    font: .santander(family: .text, type: .bold, size: 28),
                    color: .lisboaGray,
                    alignament: .center,
                    margins: Constants.absoluteMargin)),
            .margin(16.0),
            .styledText(
                LisboaDialogTextItem(
                    text: localized("login_alert_text_updateYourAppSan"),
                    font: .santander(family: .text, type: .light, size: 16),
                    color: .lisboaGray,
                    alignament: .center,
                    margins: Constants.absoluteMargin)),
            .margin(8.0),
            .image(LisboaDialogImageViewItem(image: PLAssets.image(named: "imgUpdateYourAppSan"), size: (326, 169))),
            .margin(24.0),
            .verticalAction(VerticalLisboaDialogAction(title: localized("login_label_nowUpdate"), type: LisboaDialogActionType.red, margins: (left: 16, right: 16), action: onAccept)),
            .margin(16.0)
        ]
        let builder = LisboaDialog(items: components, closeButtonAvailable: true)
        builder.showIn(viewController)
    }
}

//
//  AuthorizationDialogFactory.swift
//  Authorization
//
//  Created by Vasyl Skop on 14/04/2022.
//

import CoreFoundationLib
import UI

final class AuthorizationDialogFactory {
    
    //MARK: - Time Is Up Dialog
    static func makeTimeIsUpDialog(onAccept: @escaping () -> Void) -> LisboaDialog {
        let title = LisboaDialogTextItem(text: localized("pl_onboarding_alert_timeExpTitle"),
                                         font: .santander(family: .headline, type: .bold, size: 24),
                                         color: .black,
                                         alignament: .center,
                                         margins: (left: 16.0, right: 16.0))
        
        let body = LisboaDialogTextItem(text: localized("pl_onboarding_alert_timeExpText"),
                                        font: .santander(family: .micro, type: .light, size: 16),
                                        color: .lisboaGray,
                                        alignament: .center,
                                        margins: (left: 16.0, right: 16.0))
        
        return LisboaDialog(items: [
            .margin(30.0),
            .image(LisboaDialogImageViewItem(image: UIImage(named: "warningSymbol", in: .module, compatibleWith: nil),
                                             size: (left: 64, right: 64))),
            .margin(15.0),
            .styledText(title),
            .margin(16.0),
            .styledText(body),
            .margin(24.0),
            .verticalAction(VerticalLisboaDialogAction(title: localized("generic_button_understand"),
                                                       type: .red,
                                                       margins: (left: 16, right: 16),
                                                       action: onAccept)),
            .margin(24.0)
        ], closeButtonAvailable: false)
    }
    
    //MARK: - Success Dialog
    static func makeSuccessDialog(onAccept: @escaping () -> Void) -> LisboaDialog {
        let title = LisboaDialogTextItem(text: localized("pl_generic_successTitle_allRight"),
                                         font: .santander(family: .headline, type: .bold, size: 24),
                                         color: .black,
                                         alignament: .center,
                                         margins: (left: 16.0, right: 16.0))
        
        let body = LisboaDialogTextItem(text: localized("pl_generic_successText_allRight"),
                                        font: .santander(family: .micro, type: .light, size: 16),
                                        color: .lisboaGray,
                                        alignament: .center,
                                        margins: (left: 16.0, right: 16.0))
        
        return LisboaDialog(items: [
            .margin(30.0),
            .image(LisboaDialogImageViewItem(image: UIImage(named: "okSymbol", in: .module, compatibleWith: nil),
                                             size: (left: 64, right: 64))),
            .margin(15.0),
            .styledText(title),
            .margin(16.0),
            .styledText(body),
            .margin(24.0),
            .verticalAction(VerticalLisboaDialogAction(title: localized("generic_button_understand"),
                                                       type: .red,
                                                       margins: (left: 16, right: 16),
                                                       action: onAccept)),
            .margin(24.0)
        ], closeButtonAvailable: false)
    }
    
    //MARK: - Error Dialog
    static func makeErrorDialog(onAccept: @escaping () -> Void) -> LisboaDialog {
        let title = LisboaDialogTextItem(text: localized("sendMoney_title_somethingIsWrong"),
                                         font: .santander(family: .headline, type: .bold, size: 24),
                                         color: .black,
                                         alignament: .center,
                                         margins: (left: 16.0, right: 16.0))
        
        let body = LisboaDialogTextItem(text: localized("sendMoney_text_somethingIsWrong"),
                                        font: .santander(family: .micro, type: .light, size: 16),
                                        color: .lisboaGray,
                                        alignament: .center,
                                        margins: (left: 16.0, right: 16.0))
        
        return LisboaDialog(items: [
            .margin(30.0),
            .image(LisboaDialogImageViewItem(image: UIImage(named: "warningSymbol", in: .module, compatibleWith: nil),
                                             size: (left: 64, right: 64))),
            .margin(15.0),
            .styledText(title),
            .margin(16.0),
            .styledText(body),
            .margin(24.0),
            .verticalAction(VerticalLisboaDialogAction(title: localized("generic_button_understand"),
                                                       type: .red,
                                                       margins: (left: 16, right: 16),
                                                       action: onAccept)),
            .margin(24.0)
        ], closeButtonAvailable: false)
    }
    
    //MARK: - Close Dialog
    static func makeCloseDialog(onAccept: @escaping () -> Void) -> LisboaDialog {
        let title = LisboaDialogTextItem(text: localized("sendMoney_title_DoYouWantToFinish"),
                                         font: .santander(family: .text, type: .regular, size: 29),
                                         color: .black,
                                         alignament: .center,
                                         margins: (left: 16.0, right: 16.0))
        
        let body = LisboaDialogTextItem(text: localized("sendMoney_text_DoYouWantToFinish"),
                                        font: .santander(family: .text, type: .light, size: 16),
                                        color: .lisboaGray,
                                        alignament: .center,
                                        margins: (left: 16.0, right: 16.0))
        
        let cancelButton = LisboaDialogAction(title: localized("generic_link_cancel"),
                                              type: .white,
                                              margins: (left: 16.0, right: 16.0),
                                              action: {})
        
        let okButton = LisboaDialogAction(title: localized("generic_button_finish"),
                                          type: .red,
                                          margins: (left: 16.0, right: 16.0),
                                          action: onAccept)
        
        return LisboaDialog(items: [
            .margin(30.0),
            .image(LisboaDialogImageViewItem(image: UIImage(named: "warningSymbol", in: .module, compatibleWith: nil),
                                             size: (left: 64, right: 64))),
            .margin(15.0),
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

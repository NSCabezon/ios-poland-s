//
//  ConfirmationAlertFactory.swift
//  BLIK
//
//  Created by 186491 on 24/06/2021.
//

import UIKit
import UI
import CoreFoundationLib

public protocol ConfirmationDialogProducing {
    func create(
        message: String,
        confirmAction: @escaping () -> Void,
        declineAction: @escaping () -> Void
    ) -> LisboaDialog
    
    func createEndProcessDialog(
        confirmAction: @escaping () -> Void,
        declineAction: @escaping () -> Void
    ) -> LisboaDialog
    
    func createLimitIncreasingDialog(
        confirmAction: @escaping () -> Void,
        declineAction: @escaping () -> Void
    ) -> LisboaDialog
}

public final class ConfirmationDialogFactory: ConfirmationDialogProducing {
    public init() {}
    
    public func create(
        message: String,
        confirmAction: @escaping () -> Void,
        declineAction: @escaping () -> Void
    ) -> LisboaDialog {
        return LisboaDialog(
            items: [
                .margin(16),
                .image(.init(image: Assets.image(named: "icnAlertView"),
                             size: (51, 51),
                             contentMode: .center)
                ),
                .margin(8),
                .styledText(
                    .init(
                        text: .plain(text: message),
                        font: UIFont.santander(
                            family: .micro,
                            type: .bold,
                            size: 16
                        ),
                        color: .lisboaGray,
                        alignament: .center,
                        margins: (left: 24, right: 24)
                    )
                ),
                .margin(24),
                horizontalActions(confirmAction: confirmAction, declineAction: declineAction)
            ],
            closeButtonAvailable: false
        )
    }
    
    public func createEndProcessDialog(
        confirmAction: @escaping () -> Void,
        declineAction: @escaping () -> Void
    ) -> LisboaDialog {
        return LisboaDialog(
            items: [
                .image(.init(image: Assets.image(named: "icnAlertView"),
                             size: (51, 51),
                             contentMode: .center)
                ),
                .margin(8),
                .styledText(
                    .init(text: localized("generic_alert_quitTitle"),
                          font: .santander(family: .headline, type: .bold, size: 28),
                          color: .lisboaGray,
                          alignament: .center,
                          margins: (16, 16))
                ),
                .margin(16),
                .styledText(
                    .init(
                        text: localized("generic_alert_quitText"),
                        font: UIFont.santander(
                            family: .micro,
                            type: .regular,
                            size: 16
                        ),
                        color: .lisboaGray,
                        alignament: .center,
                        margins: (left: 24, right: 24)
                    )
                ),
                .margin(24),
                horizontalActions(confirmAction: confirmAction, declineAction: declineAction)
            ],
            closeButtonAvailable: true
        )
    }
    
    public func createLimitIncreasingDialog(
        confirmAction: @escaping () -> Void,
        declineAction: @escaping () -> Void
    ) -> LisboaDialog {
        return LisboaDialog(
            items: [
                .image(.init(image: Assets.image(named: "icnAlertView"),
                             size: (51, 51),
                             contentMode: .center)
                ),
                .margin(8),
                .styledText(
                    .init(text: localized("pl_blik_title_limitDown"),
                          font: .santander(family: .headline, type: .bold, size: 28),
                          color: .lisboaGray,
                          alignament: .center,
                          margins: (16, 16))
                ),
                .margin(16),
                .styledText(
                    .init(
                        text: localized("pl_blik_text_limitDownInfo"),
                        font: UIFont.santander(
                            family: .micro,
                            type: .regular,
                            size: 16
                        ),
                        color: .lisboaGray,
                        alignament: .center,
                        margins: (left: 24, right: 24)
                    )
                ),
                .margin(24),
                .horizontalActions(
                    .init(
                        left: .init(
                            title: .plain(text: localized("generic_button_cancel")),
                            type: .white,
                            margins: (left: 16, right: 8),
                            action: { declineAction() }
                        ),
                        right: .init(
                            title: .plain(text: localized("pl_blik_button_limitDown")),
                            type: .red,
                            margins: (left: 16, right: 8),
                            action: { confirmAction() }
                        )
                    )
                )
            ],
            closeButtonAvailable: true
        )
    }
}

private extension ConfirmationDialogFactory {
    func horizontalActions(
        confirmAction: @escaping () -> Void,
        declineAction: @escaping () -> Void
    ) -> LisboaDialogItem {
        .horizontalActions(
            .init(
                left: .init(
                    title: .plain(text: localized("generic_link_no")),
                    type: .white,
                    margins: (left: 16, right: 8),
                    action: { declineAction() }
                ),
                right: .init(
                    title: .plain(text: localized("generic_link_yes")),
                    type: .red,
                    margins: (left: 16, right: 8),
                    action: { confirmAction() }
                )
            )
        )
    }
}

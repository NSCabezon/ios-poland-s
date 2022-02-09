//
//  UnregisterPhoneNumberConfirmationFactory.swift
//  BLIK
//
//  Created by Piotr Mielcarzewicz on 19/08/2021.
//

import UIKit
import UI
import CoreFoundationLib

public protocol UnregisterPhoneNumberConfirmationProducing {
    func create(
        confirmAction: @escaping () -> Void,
        declineAction: @escaping () -> Void,
        accountToUnregisterNumber: String
    ) -> LisboaDialog
}

public final class UnregisterPhoneNumberConfirmationFactory: UnregisterPhoneNumberConfirmationProducing {
    public init() {}
    
    public func create(
        confirmAction: @escaping () -> Void,
        declineAction: @escaping () -> Void,
        accountToUnregisterNumber: String
    ) -> LisboaDialog {
        return LisboaDialog(
            items: [
                .margin(16),
                .styledText(
                    .init(
                        text: .plain(text: localized("pl_blik_title_alert_deRegist")),
                        font: UIFont.santander(
                            family: .micro,
                            type: .bold,
                            size: 24
                        ),
                        color: .lisboaGray,
                        alignament: .center,
                        margins: (left: 24, right: 24)
                    )
                ),
                .margin(16),
                .styledText(
                    .init(
                        text: .plain(text: localized("pl_blik_text_alert_deRegist")),
                        font: UIFont.santander(
                            family: .micro,
                            type: .regular,
                            size: 14
                        ),
                        color: .lisboaGray,
                        alignament: .center,
                        margins: (left: 24, right: 24)
                    )
                ),
                .margin(16),
                .styledText(
                    .init(
                        text: .plain(text: localized("pl_blik_text_declarationRegist")),
                        font: UIFont.santander(
                            family: .micro,
                            type: .bold,
                            size: 14
                        ),
                        color: .lisboaGray,
                        alignament: .left,
                        margins: (left: 24, right: 24)
                    )
                ),
                .margin(4),
                .styledText(
                    .init(
                        text: localized("pl_blik_text_deRegistMeaning",
                                        [StringPlaceholder(.value, "\(accountToUnregisterNumber)")]),
                        font: UIFont.santander(
                            family: .micro,
                            type: .regular,
                            size: 12
                        ),
                        color: .lisboaGray,
                        alignament: .left,
                        margins: (left: 24, right: 24)
                    )
                ),
                .horizontalActions(
                    .init(
                        left: .init(
                            title: .plain(text: localized("generic_button_cancel")),
                            type: .white,
                            margins: (left: 16, right: 8),
                            action: { declineAction() }
                        ),
                        right: .init(
                            title: .plain(text: localized("pl_blik_button_deRegist")),
                            type: .red,
                            margins: (left: 16, right: 8),
                            action: { confirmAction() }
                        )
                    )
                )
            ],
            closeButtonAvailable: false
        )
    }
}


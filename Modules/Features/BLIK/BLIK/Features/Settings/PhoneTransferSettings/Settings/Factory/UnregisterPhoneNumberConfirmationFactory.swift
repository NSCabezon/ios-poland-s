//
//  UnregisterPhoneNumberConfirmationFactory.swift
//  BLIK
//
//  Created by Piotr Mielcarzewicz on 19/08/2021.
//

import UIKit
import UI
import Commons

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
                        text: .plain(text: "#Czy na pewno chcesz się wyrejestrować z bazy powiązań BLIK?"),
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
                        text: .plain(text: "#Po wyrejestrowaniu nie będziesz już mógł otrzymywać przelewów na telefon.\nW każdej chwili będziesz mógł się zarejestrować ponownie przechodząc do Ustawienia > Przelew na telefon."),
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
                        text: .plain(text: "#Oświadczenie"),
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
                        text: .plain(text: "#Odwołuję złożoną przeze mnie w Santander Bank Polska S.A. dyspozycję otrzymywania na moim rachunku bankowym \(accountToUnregisterNumber) Przelewów na telefon BLIK wysyłanych na numer telefonu komórkowego służący do przesyłania przez Santander Bank Polska S.A. smsKodów."),
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
                            title: .plain(text: "#Anuluj"),
                            type: .white,
                            margins: (left: 16, right: 8),
                            action: { declineAction() }
                        ),
                        right: .init(
                            title: .plain(text: "#Wyrejestruj"),
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


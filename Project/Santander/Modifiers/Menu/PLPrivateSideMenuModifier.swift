//
//  PLPrivateSideMenuModifier.swift
//  Santander
//
//  Created by Alvaro Royo on 10/11/21.
//

import RetailLegacy
import Menu
import Models

class PLPrivateSideMenuModifier: PrivateSideMenuModifier {
    func getConfiguration(globalPosition: GlobalPositionRepresentable) -> InfoSideMenuViewModel {
        let name = globalPosition.clientNameWithoutSurname ?? ""
        let surname = globalPosition.clientSecondSurname ?? ""
        return InfoSideMenuViewModel(
            availableName: name + " " + surname,
            initials: "\(name.prefix(1))\(surname.prefix(1))"
        )
    }
}

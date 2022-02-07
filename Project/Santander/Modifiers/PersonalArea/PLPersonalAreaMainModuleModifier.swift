//
//  PLPersonalAreaMainModuleModifier.swift
//  Santander
//
//  Created by Alvaro Royo on 10/11/21.
//

import Foundation
import CoreFoundationLib
import PersonalArea
import PLLegacyAdapter
import SANLegacyLibrary

class PLPersonalAreaMainModuleModifier: PersonalAreaMainModuleModifier {
    let dependenciesResolver: DependenciesResolver
    
    init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
    }
    
    func getName() -> String {
        let manager: BSANManagersProvider = dependenciesResolver.resolve()
        let globalPosition = try? manager.getBsanPGManager().getGlobalPosition().getResponseData()
        let name = globalPosition?.clientNameWithoutSurname
        let secondName = globalPosition?.clientFirstSurname?.surname
        let surname = globalPosition?.clientSecondSurname?.surname
        return concat(strings: [name, secondName, surname])
    }
    
    private func concat(strings: [String?]) -> String {
        var string = ""
        strings.enumerated().forEach({
            guard let str = $1, !str.isEmpty else { return }
            if $0 > 0 { string += " " }
            string += str
        })
        return string
    }
}

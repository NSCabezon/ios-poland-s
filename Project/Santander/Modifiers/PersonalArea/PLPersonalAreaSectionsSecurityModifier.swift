//
//  PLPersonalAreaSectionsSecurityModifier.swift
//  Santander
//
//  Created by Rubén Muñoz López on 8/9/21.
//

import Foundation
import SANPLLibrary
import Commons
import PersonalArea

final class PLPersonalAreaSectionsSecurityModifier {
    private let managersProvider: PLManagersProviderProtocol
    private let dependenciesEngine: DependenciesResolver & DependenciesInjector

    init(dependenciesEngine: DependenciesResolver & DependenciesInjector) {
        self.managersProvider = dependenciesEngine.resolve(for: PLManagersProviderProtocol.self)
        self.dependenciesEngine = dependenciesEngine
    }
}

extension PLPersonalAreaSectionsSecurityModifier: PersonalAreaSectionsSecurityModifierProtocol {
    var isDisabledUserPoland: Bool {
        return false
    }
    var isEnabledPasswordPoland: Bool {
        return false
    }
    var isEnabledSignaturePoland : Bool {
        return false
    }
    var isEnabledDataPrivacyPoland: Bool {
        return false
    }
    var isDisabledLastAccessPoland: Bool {
        return false
    }
}

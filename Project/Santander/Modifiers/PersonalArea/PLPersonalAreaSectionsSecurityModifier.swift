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
    var isDisabledUser: Bool {
        return false
    }
    var isEnabledPassword: Bool {
        return false
    }
    var isEnabledSignature: Bool {
        return false
    }
    var isEnabledDataPrivacy: Bool {
        return false
    }
    var isDisabledLastAccess: Bool {
        return false
    }
    var isESignatureFunctionalityEnabled: Bool {
        return false
    }
}

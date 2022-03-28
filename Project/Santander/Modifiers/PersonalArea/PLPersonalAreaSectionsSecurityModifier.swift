//
//  PLPersonalAreaSectionsSecurityModifier.swift
//  Santander
//
//  Created by Rubén Muñoz López on 8/9/21.
//

import CoreFoundationLib
import PersonalArea
import SANPLLibrary

final class PLPersonalAreaSectionsSecurityModifier {
    init() {}
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
    var isEnabledLastAccess: Bool {
        return true
    }
    var isESignatureFunctionalityEnabled: Bool {
        return false
    }
    var isBiometryFunctionalityEnabled: Bool {
        return false
    }
    var isEnabledQuickerBalance: Bool {
        return true
    }
}

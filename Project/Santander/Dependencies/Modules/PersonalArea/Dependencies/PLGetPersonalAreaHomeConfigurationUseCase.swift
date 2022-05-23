//
//  PLGetPersonalAreaHomeConfigurationUseCase.swift
//  Santander
//
//  Created by alvola on 19/4/22.
//

import Foundation
import OpenCombine
import PersonalArea

struct PLGetPersonalAreaHomeConfigurationUseCase: GetPersonalAreaHomeConfigurationUseCase {
    func fetchPersonalAreaHomeConfiguration() -> AnyPublisher<PersonalAreaHomeRepresentable, Never> {
        return Just(PLPersonalAreaHome()).eraseToAnyPublisher()
    }
}

private extension PLGetPersonalAreaHomeConfigurationUseCase {
    struct PLPersonalAreaHome: PersonalAreaHomeRepresentable {
        var isEnabledDigitalProfileView: Bool = false
        var digitalProfileInfo: PersonalAreaDigitalProfileRepresentable?
        var isPersonalAreaSecuritySettingEnabled: Bool = true
        var isPersonalDocOfferEnabled: Bool = true
        var isRecoveryOfferEnabled: Bool = false
    }
}

//
//  PLGetHomeUserPreferencesUseCase.swift
//  Santander
//
//  Created by alvola on 25/4/22.
//

import Foundation
import PersonalArea
import OpenCombine
import CoreFoundationLib
import CoreDomain

struct PLGetHomeUserPreferencesUseCase {
    private let appConfigRepository: AppConfigRepositoryProtocol
    
    init(dependencies: PersonalAreaHomeExternalDependenciesResolver) {
        self.appConfigRepository = dependencies.resolve()
    }
}

extension PLGetHomeUserPreferencesUseCase: GetHomeUserPreferencesUseCase {
    func fetchUserPreferences() -> AnyPublisher<PersonalAreaDigitalProfileAndSecurityEnable, Never> {
        return self.appConfigRepository
            .value(for: PersonalAreaConstants.isPersonalAreaSecuritySettingEnabled, defaultValue: false)
            .map { respose in
                return PersonalAreaDigitalProfileAndSecurityEnable(isEnabledDigitalProfileView: true,
                                                                   isPersonalAreaSecuritySettingEnabled: respose)
            }
            .eraseToAnyPublisher()
    }
}

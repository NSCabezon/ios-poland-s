//
//  ESGetPersonalAreaConfigurationPreferencesUseCase.swift
//  Santander
//
//  Created by Juan Jose Acosta on 28/4/22.
//

import CoreDomain
import CoreFoundationLib
import OpenCombine
import PersonalArea

public struct PLGetPersonalAreaConfigurationPreferencesUseCase {
    private let globalPositionRepository: GlobalPositionDataRepository
    private let appConfigRepository: AppConfigRepositoryProtocol
    private let appRepository: AppRepositoryProtocol
    private let photoThemeModifier: PhotoThemeModifierProtocol?
    private let isEnabledConfigureAlertsInMenu: Bool = false
    private let isEnabledLaguageSelection: Bool = true
    private let isEnabledNavigationPG: Bool = true
    private let isEnabledNavigationPhotoTheme: Bool = true
    private let isEnabledNavigationAlerts: Bool = true

    public init(dependencies: PersonalAreaConfigurationExternalDependenciesResolver) {
        self.appRepository = dependencies.resolve()
        self.appConfigRepository = dependencies.resolve()
        self.globalPositionRepository = dependencies.resolve()
        self.photoThemeModifier = dependencies.resolve()
    }
}

extension PLGetPersonalAreaConfigurationPreferencesUseCase: GetPersonalAreaConfigurationPreferencesUseCase {

    public func fetchConfigurationPreferences() -> AnyPublisher<PersonalAreaConfigurationPreferencesValuesRepresentable, Never> {
        return globalPositionRepository
            .getGlobalPosition()
            .flatMap(getPreferencesData)
            .eraseToAnyPublisher()
    }
}

private extension PLGetPersonalAreaConfigurationPreferencesUseCase {
    func getPreferencesData(_ globalPositionData: GlobalPositionDataRepresentable) -> AnyPublisher<PersonalAreaConfigurationPreferencesValuesRepresentable,Never> {
        return Publishers.Zip3(
            appRepository.getCurrentLanguagePublisher(),
            getAppInfoEnabled(),
            getUserPref(globalPositionData)
        ).map(composeResponseObject)
            .eraseToAnyPublisher()
    }

    func getAppInfoEnabled() -> AnyPublisher<Bool,Never> {
        return appConfigRepository.value(for: "enableAppInfo", defaultValue: false).eraseToAnyPublisher()
    }
    
    func composeResponseObject(
        _ language: Language,
        _ isAppInfoEnabled: Bool,
        _ userPref: UserPrefDTOEntity
    ) -> PersonalAreaConfigurationPreferencesValuesRepresentable {
        var photoThemeId = BackgroundImagesTheme.defaultTheme
        if let photoThemeSelected = userPref.pgUserPrefDTO.photoThemeOptionSelected {
            photoThemeId = photoThemeSelected
        }
        let photoThemeName = getPhotoThemeInfo(photoThemeId)
        
        let values = PersonalAreaConfigurationPreferencesValues(
            currentLanguageName: language.languageType.languageName,
            photoThemeName: photoThemeName,
            isAppInfoEnabled: isAppInfoEnabled,
            isEnabledConfigureAlertsInMenu: self.isEnabledConfigureAlertsInMenu,
            isEnabledLaguageSelection: self.isEnabledLaguageSelection,
            isEnabledNavigationPG: self.isEnabledNavigationPG,
            isEnabledNavigationPhotoTheme: self.isEnabledNavigationPhotoTheme,
            isEnabledNavigationAlerts: self.isEnabledNavigationAlerts
        )

        return values
    }
    
    func getUserPref(_ globalPositionData: GlobalPositionDataRepresentable) ->  AnyPublisher<UserPrefDTOEntity, Never> {
        let userId = globalPositionData.userId ?? ""
        return appRepository
            .getReactiveUserPreferences(userId: userId)
            .replaceError(with: UserPrefDTOEntity(userId: userId))
            .eraseToAnyPublisher()
    }

    func getPhotoThemeInfo(_ photoThemeId: Int?) -> String {
        guard let currentPhotoThemeId = photoThemeId else {
            return PhotoThemeOption(rawValue: -1)?.titleKey() ?? ""
        }
        guard let titleKey = PhotoThemeOption(rawValue: currentPhotoThemeId)?.titleKey() else {
            return photoThemeModifier?.getPhotoThemeInfo(for: currentPhotoThemeId)?.titleKey ?? ""
        }
        return titleKey
    }
}

struct PersonalAreaConfigurationPreferencesValues: PersonalAreaConfigurationPreferencesValuesRepresentable {
    var currentLanguageName: String
    var photoThemeName: String
    var isAppInfoEnabled: Bool
    var isEnabledConfigureAlertsInMenu: Bool
    var isEnabledLaguageSelection: Bool
    var isEnabledNavigationPG: Bool
    var isEnabledNavigationPhotoTheme: Bool
    var isEnabledNavigationAlerts: Bool
}

//
//  PLGetUserPreferencesUseCase.swift
//  PLLogin
//
//  Created by Mario Rosales Maillo on 22/10/21.
//

import Foundation
import DomainCommon
import iOSCommonPublicFiles
import Models
import Commons
import PLCommons
import Repository

final class PLGetUserPreferencesUseCase: UseCase<PLGetUserPrefEntityUseCaseInput, PLGetUserPrefEntityUseCaseOutput, PLUseCaseErrorOutput<LoginErrorType>>, PLLoginUseCaseErrorHandlerProtocol {
    private let dependenciesResolver: DependenciesResolver
    private let appRepository: AppRepositoryProtocol
    private let defaultTheme: BackgroundImagesTheme = .nature
    
    init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
        self.appRepository = self.dependenciesResolver.resolve(for: AppRepositoryProtocol.self)
    }

    override func executeUseCase(requestValues: PLGetUserPrefEntityUseCaseInput) throws -> UseCaseResponse<PLGetUserPrefEntityUseCaseOutput, PLUseCaseErrorOutput<LoginErrorType>> {
        let userPrefEntity = appRepository.getUserPreferences(userId: String(requestValues.userId))
        let persistedUser = try appRepository.getPersistedUser().getResponseData()
        let theme = getBackgroundTheme(for: userPrefEntity.pgUserPrefDTO.photoThemeOptionSelected)
        let biometrics = userPrefEntity.pgUserPrefDTO.touchOrFaceIdProfileSaved
        let alias = userPrefEntity.pgUserPrefDTO.alias
        let name = (alias != "" ? alias : persistedUser?.name ?? "").lowercased().capitalized
        let output = PLGetUserPrefEntityUseCaseOutput(name: name, theme: theme, biometricsEnabled: biometrics)
        return UseCaseResponse.ok(output)
    }
}

private extension PLGetUserPreferencesUseCase {
    
    var photoThemeModifier: PhotoThemeModifierProtocol? {
        return dependenciesResolver.resolve(forOptionalType: PhotoThemeModifierProtocol.self)
    }
    
    func getBackgroundTheme(for identifier: Int?) -> BackgroundImagesTheme {
        guard let identifier = identifier else { return self.defaultTheme }
        guard let theme = BackgroundImagesTheme(id: identifier) else {
            return photoThemeModifier?.getBackGroundImage(for: identifier) ?? self.defaultTheme
        }
        return theme
    }
}

struct PLGetUserPrefEntityUseCaseOutput {
    let name: String
    let theme: BackgroundImagesTheme
    let biometricsEnabled: Bool
}

struct PLGetUserPrefEntityUseCaseInput {
    var userId: Int
}

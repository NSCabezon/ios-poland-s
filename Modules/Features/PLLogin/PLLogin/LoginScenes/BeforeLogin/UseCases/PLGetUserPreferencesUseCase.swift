//
//  PLGetUserPreferencesUseCase.swift
//  PLLogin
//
//  Created by Mario Rosales Maillo on 22/10/21.
//

import Foundation
import CoreFoundationLib
import CoreFoundationLib
import PLCommons

final class PLGetUserPreferencesUseCase: UseCase<Void, PLGetUserPrefEntityUseCaseOutput, PLUseCaseErrorOutput<LoginErrorType>>, PLLoginUseCaseErrorHandlerProtocol {
    
    private let dependenciesResolver: DependenciesResolver
    private let appRepository: AppRepositoryProtocol
    private let defaultTheme: BackgroundImagesTheme = .nature
    
    init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
        self.appRepository = self.dependenciesResolver.resolve(for: AppRepositoryProtocol.self)
    }

    override func executeUseCase(requestValues: Void) throws -> UseCaseResponse<PLGetUserPrefEntityUseCaseOutput, PLUseCaseErrorOutput<LoginErrorType>> {
        let persistedUser = try appRepository.getPersistedUser().getResponseData()
        guard let userId = persistedUser?.userId else {
            let output = PLGetUserPrefEntityUseCaseOutput(name: "",
                                                          theme: self.defaultTheme,
                                                          biometricsEnabled: false,
                                                          userId: nil,
                                                          login: nil)
            return .ok(output)
        }
        let userPrefEntity = appRepository.getUserPreferences(userId: userId)
        let theme = getBackgroundTheme(for: userPrefEntity.pgUserPrefDTO.photoThemeOptionSelected)
        let biometrics = userPrefEntity.pgUserPrefDTO.touchOrFaceIdProfileSaved
        let alias = userPrefEntity.pgUserPrefDTO.alias
        let name = (alias != "" ? alias : persistedUser?.name ?? "").lowercased().capitalized
        let output = PLGetUserPrefEntityUseCaseOutput(name: name,
                                                      theme: theme,
                                                      biometricsEnabled: biometrics,
                                                      userId: userId,
                                                      login: persistedUser?.login)
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
    let userId: String?
    let login: String?
}

//
//  LoadPLTermsAndConditionsUseCase.swift
//  Santander
//
//  Created by Mario Rosales Maillo on 3/2/22.
//

import Foundation
import CoreFoundationLib

public final class LoadPLTermsAndConditionsUseCase: UseCase<Void, Void, StringErrorOutput> {
    private let dependencies: DependenciesResolver
    private let termsAndConditionsRepository: PLTermsAndConditionsRepository
    private let appRepository: AppRepositoryProtocol
    
    public init(dependencies: DependenciesResolver) {
        self.dependencies = dependencies
        self.termsAndConditionsRepository = dependencies.resolve(for: PLTermsAndConditionsRepository.self)
        self.appRepository = dependencies.resolve(for: AppRepositoryProtocol.self)
    }
    
    override public func executeUseCase(requestValues: Void) throws -> UseCaseResponse<Void, StringErrorOutput> {
        if let urlBase = try appRepository.getCurrentPublicFilesEnvironment().getResponseData()?.urlBase {
            let languageType: LanguageType
            if let response = try appRepository.getLanguage().getResponseData(), let type = response {
                languageType = type
            } else {
                let defaultLanguage = self.dependencies.resolve(for: LocalAppConfig.self).language
                let languageList = self.dependencies.resolve(for: LocalAppConfig.self).languageList
                languageType = Language.createDefault(isPb: nil, defaultLanguage: defaultLanguage, availableLanguageList: languageList).languageType
            }
            self.termsAndConditionsRepository.load(baseUrl: urlBase, publicLanguage: languageType.getPublicLanguage)
        }
        return UseCaseResponse.ok()
    }
}

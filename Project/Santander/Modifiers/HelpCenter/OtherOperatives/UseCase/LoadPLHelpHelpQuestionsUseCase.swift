//
//  LoadPLHelpHelpQuestionsUseCase.swift
//  Santander
//
//  Created by 185860 on 19/01/2022.
//

import CoreFoundationLib
import CoreFoundationLib
import RetailLegacy
import SANPLLibrary
import SANLegacyLibrary
import PLHelpCenter

class LoadPLHelpHelpQuestionsUseCase: UseCase<Void, Void, StringErrorOutput> {
    private let dependencies: DependenciesResolver
    private var plHelpHelpQuestionsRepository: PLHelpQuestionsRepository
    private let appRepository: AppRepositoryProtocol
    
    init(dependencies: DependenciesResolver) {
        self.dependencies = dependencies
        self.plHelpHelpQuestionsRepository = dependencies.resolve(for: PLHelpQuestionsRepository.self)
        self.appRepository = dependencies.resolve(for: AppRepositoryProtocol.self)
    }
    
    override public func executeUseCase(requestValues: Void) throws -> UseCaseResponse<Void, StringErrorOutput> {
        if let urlBase = try appRepository.getCurrentPublicFilesEnvironment().getResponseData()?.urlBase {
            plHelpHelpQuestionsRepository.load(withBaseUrl: urlBase)
            let languageType: LanguageType
            if let response = try appRepository.getLanguage().getResponseData(), let type = response {
                languageType = type
            } else {
                let defaultLanguage = self.dependencies.resolve(for: LocalAppConfig.self).language
                let languageList = self.dependencies.resolve(for: LocalAppConfig.self).languageList
                languageType = Language.createDefault(isPb: nil, defaultLanguage: defaultLanguage, availableLanguageList: languageList).languageType
            }
            plHelpHelpQuestionsRepository.load(baseUrl: urlBase, publicLanguage: languageType.getPublicLanguage)
        }
        
        return UseCaseResponse.ok()
    }
}

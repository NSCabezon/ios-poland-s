//
//  LoadPLTransferSettingsUseCase.swift
//  Santander
//
//  Created by 187125 on 16/12/2021.
//

import CoreFoundationLib
import CoreFoundationLib
import RetailLegacy

final class LoadPLTransferSettingsUseCase: UseCase<Void, Void, StringErrorOutput> {
    private let dependencies: DependenciesResolver
    private let plTransferSettingsRepository: PLTransferSettingsRepository
    private let appRepository: AppRepositoryProtocol
    
    init(dependencies: DependenciesResolver) {
        self.dependencies = dependencies
        self.plTransferSettingsRepository = dependencies.resolve(for: PLTransferSettingsRepository.self)
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
            self.plTransferSettingsRepository.load(baseUrl: urlBase, publicLanguage: languageType.getPublicLanguage)
        }
        return UseCaseResponse.ok()
    }
}

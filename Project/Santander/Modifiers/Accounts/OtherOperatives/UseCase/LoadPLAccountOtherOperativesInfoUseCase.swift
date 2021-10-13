//
//  LoadPLAccountOtherOperativesInfoUseCase.swift
//  Santander
//
//  Created by Julio Nieto Santiago on 7/10/21.
//

import DomainCommon
import Commons
import RetailLegacy
import Repository

class LoadPLAccountOtherOperativesInfoUseCase: UseCase<Void, Void, StringErrorOutput> {
    private let dependencies: DependenciesResolver
    private let plAccountOtherOperativesInfoRepository: PLAccountOtherOperativesInfoRepository
    private let appRepository: AppRepositoryProtocol
    
    init(dependencies: DependenciesResolver, plAccountOtherOperativesInfoRepository: PLAccountOtherOperativesInfoRepository, appRepository: AppRepositoryProtocol) {
        self.dependencies = dependencies
        self.plAccountOtherOperativesInfoRepository = plAccountOtherOperativesInfoRepository
        self.appRepository = appRepository
    }
    
    override public func executeUseCase(requestValues: Void) throws -> UseCaseResponse<Void, StringErrorOutput> {
        if let urlBase = try appRepository.getCurrentPublicFilesEnvironment().getResponseData()?.urlBase {
            let languageType: LanguageType
            if let response = try appRepository.getLanguage().getResponseData(), let type = response {
                languageType = type
            } else {
                let defaultLanguage = self.dependencies.resolve(for: LocalAppConfig.self).language
                languageType = Language.createDefault(isPb: nil, defaultLanguage: defaultLanguage).languageType
            }
            self.plAccountOtherOperativesInfoRepository.load(baseUrl: urlBase, publicLanguage: languageType.getPublicLanguage)
        }
        return UseCaseResponse.ok()
    }
}

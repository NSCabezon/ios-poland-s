//
//  LoadPLHelpCenterOnlineAdvisorRepository.swift
//  Santander
//
//  Created by 185860 on 18/01/2022.
//

import CoreFoundationLib
import Commons
import RetailLegacy
import SANPLLibrary
import SANLegacyLibrary
import PLHelpCenter

class LoadPLHelpCenterOnlineAdvisorUseCase: UseCase<Void, Void, StringErrorOutput> {
    private let dependencies: DependenciesResolver
    private var plHelpCenterOnlineAdvisorRepository: PLHelpCenterOnlineAdvisorRepository
    private let appRepository: AppRepositoryProtocol
    
    init(dependencies: DependenciesResolver) {
        self.dependencies = dependencies
        self.plHelpCenterOnlineAdvisorRepository = dependencies.resolve(for: PLHelpCenterOnlineAdvisorRepository.self)
        self.appRepository = dependencies.resolve(for: AppRepositoryProtocol.self)
    }
    
    override public func executeUseCase(requestValues: Void) throws -> UseCaseResponse<Void, StringErrorOutput> {
        if let urlBase = try appRepository.getCurrentPublicFilesEnvironment().getResponseData()?.urlBase {
            plHelpCenterOnlineAdvisorRepository.load(withBaseUrl: urlBase)
        }
        
        return UseCaseResponse.ok()
    }
}

//
//  GetPLAccountOtherOperativesWebConfigurationUseCase.swift
//  Santander
//
//  Created by Julio Nieto Santiago on 29/9/21.
//

import Foundation
import Commons
import DomainCommon
import SANLegacyLibrary
import SANPLLibrary

class GetPLAccountOtherOperativesWebConfigurationUseCase: UseCase<GetPLAccountOtherOperativesWebConfigurationUseCaseInput, GetPLAccountOtherOperativesWebConfigurationUseCaseOkOutput, StringErrorOutput> {
    private let dependenciesResolver: DependenciesResolver
    private let provider: BSANManagersProvider
    private let dataProvider: BSANDataProvider
    
    public init(dependenciesResolver: DependenciesResolver, dataProvider: BSANDataProvider) {
        self.dependenciesResolver = dependenciesResolver
        self.provider = self.dependenciesResolver.resolve(for: BSANManagersProvider.self)
        self.dataProvider = dataProvider
    }
    
    override func executeUseCase(requestValues: GetPLAccountOtherOperativesWebConfigurationUseCaseInput) throws -> UseCaseResponse<GetPLAccountOtherOperativesWebConfigurationUseCaseOkOutput, StringErrorOutput> {
        
        let closingUrl = "www.bancosantander.com"
        let initialURL = requestValues.type.link ?? ""
        let httpMethod: HTTPMethodType = requestValues.type.httpMethod ?? .post
        let parameters = try generateParameters()
        let configuration = PLAccountOtherOperativesWebConfiguration(
            initialURL: initialURL,
            bodyParameters: parameters,
            closingURLs: [closingUrl],
            webToolbarTitleKey: " ",
            httpMethod: httpMethod,
            pdfToolbarTitleKey: " ")
        return UseCaseResponse.ok(GetPLAccountOtherOperativesWebConfigurationUseCaseOkOutput(configuration: configuration))
    }
}

extension GetPLAccountOtherOperativesWebConfigurationUseCase {
    func getAccessToken() -> String {
        guard let authCredentials = try? self.dataProvider.getAuthCredentials() else { return "" }
        guard let accessToken = authCredentials.accessTokenCredentials?.accessToken else {
            return ""
        }
        return accessToken
    }
    
    func getClientId() -> String {
        guard let authCredentials = try? self.dataProvider.getAuthCredentials() else { return "" }
        guard let userId = authCredentials.userId else {
            return ""
        }
        let clientId = "\(userId)"
        return clientId
    }
    
    func generateParameters() throws -> [String : String] {
        let access_token = getAccessToken()
        let clientId = getClientId()
        let language = getLanguage()
        let parameters = [
            "access_token": access_token,
            "clientId": clientId,
            "mlang": language,
            "oneApp": "true"
        ]
        return parameters
    }
    
    private func getLanguage() -> String {
        return dependenciesResolver.resolve(forOptionalType: StringLoader.self)?.getCurrentLanguage().languageType.rawValue ?? "en"
    }
}

struct GetPLAccountOtherOperativesWebConfigurationUseCaseInput {
    let type: PLAccountOtherOperativesData
}

struct GetPLAccountOtherOperativesWebConfigurationUseCaseOkOutput {
    let configuration: WebViewConfiguration
}

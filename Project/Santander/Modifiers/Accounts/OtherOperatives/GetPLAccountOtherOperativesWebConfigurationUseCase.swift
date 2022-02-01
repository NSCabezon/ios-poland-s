//
//  GetPLAccountOtherOperativesWebConfigurationUseCase.swift
//  Santander
//
//  Created by Julio Nieto Santiago on 29/9/21.
//

import Foundation
import CoreFoundationLib
import CoreFoundationLib
import SANLegacyLibrary
import SANPLLibrary

class GetPLAccountOtherOperativesWebConfigurationUseCase: UseCase<GetPLAccountOtherOperativesWebConfigurationUseCaseInput, GetPLAccountOtherOperativesWebConfigurationUseCaseOkOutput, StringErrorOutput> {
    private let dependenciesResolver: DependenciesResolver
    private let provider: BSANManagersProvider
    private let dataProvider: BSANDataProvider
    private let networkProvider: NetworkProvider
    
    public init(dependenciesResolver: DependenciesResolver, dataProvider: BSANDataProvider, networkProvider: NetworkProvider) {
        self.dependenciesResolver = dependenciesResolver
        self.provider = self.dependenciesResolver.resolve(for: BSANManagersProvider.self)
        self.dataProvider = dataProvider
        self.networkProvider = networkProvider
    }
    
    override func executeUseCase(requestValues: GetPLAccountOtherOperativesWebConfigurationUseCaseInput) throws -> UseCaseResponse<GetPLAccountOtherOperativesWebConfigurationUseCaseOkOutput, StringErrorOutput> {
        
        let closingUrl = "www.bancosantander.com"
        let initialURL = requestValues.type.link ?? ""
        let httpMethod: HTTPMethodType = requestValues.type.httpMethod ?? .post
        let parameters = try generateParameters()
        let configuration = PLAccountOtherOperativesWebConfiguration(
            initialURL: initialURL,
            bodyParameters: parameters,
            closingURLs: [closingUrl, "app://close"],
            webToolbarTitleKey: " ",
            httpMethod: httpMethod,
            pdfToolbarTitleKey: " ",
            isFullScreenEnabled: requestValues.type.isFullScreen ?? true
        )
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
    
    func generateParameters() throws -> [String: String] {
        let accessToken = getAccessToken()
        let clientId = getClientId()
        let language = getLanguage()
        let profileId = getProfileId()
        let parameters = [
            "access_token": accessToken,
            "clientId": clientId,
            "mlang": language,
            "oneApp": "true",
            "profileId": profileId
        ]
        return parameters
    }
    
    private func getLanguage() -> String {
        return dependenciesResolver.resolve(forOptionalType: StringLoader.self)?.getCurrentLanguage().languageType.rawValue ?? "en"
    }

    func getProfileId() -> String {
        let result = getContext()
        
        switch result {
        case .success(let context):
            return context.profileId
        default:
            return "3"
        }
    }
    
    func getContext() -> Result<PLContextDTO, NetworkProviderError> {
        guard let baseUrl = self.getBaseUrl() else {
            return .failure(NetworkProviderError.other)
        }
        let absoluteUrl = baseUrl + "/api/as"
        let serviceName = "/context"
        let result: Result<PLContextDTO, NetworkProviderError> = self.networkProvider.request(PLContextRequest(serviceName: serviceName,
                                                                                                               serviceUrl: absoluteUrl,
                                                                                                               method: .get,
                                                                                                               headers: nil,
                                                                                                               contentType: nil,
                                                                                                               localServiceName: .authenticate)
        )
        return result
    }

    func getBaseUrl() -> String? {
        return try? self.dataProvider.getEnvironment().urlBase
    }
}

struct GetPLAccountOtherOperativesWebConfigurationUseCaseInput {
    let type: PLAccountOtherOperativesData
}

struct GetPLAccountOtherOperativesWebConfigurationUseCaseOkOutput {
    let configuration: WebViewConfiguration
}

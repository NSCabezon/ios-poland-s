//
//  GetPLCardsOtherOperativesWebConfigurationUseCase.swift
//  Santander
//
//  Created by Julio Nieto Santiago on 13/10/21.
//

import Foundation
import Commons
import CoreFoundationLib
import SANLegacyLibrary
import SANPLLibrary

class GetPLCardsOtherOperativesWebConfigurationUseCase: UseCase<GetPLCardsOtherOperativesWebConfigurationUseCaseInput, GetPLCardsOtherOperativesWebConfigurationUseCaseOkOutput, StringErrorOutput> {
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
    
    override func executeUseCase(requestValues: GetPLCardsOtherOperativesWebConfigurationUseCaseInput) throws -> UseCaseResponse<GetPLCardsOtherOperativesWebConfigurationUseCaseOkOutput, StringErrorOutput> {

        let cardEntity = requestValues.cardEntity
        let cardData = requestValues.cardData
        let closingUrl = "www.bancosantander.com"
        var initialURL = ""
        var httpMethodCard: HTTPMethodType = .get
        if let pan = cardEntity.dto.contract?.contractNumber, let httpMethod = cardData.httpMethod, let url = cardData.link {
            initialURL = url.replacingOccurrences(of: "{$VPAN}", with: pan)
            httpMethodCard = httpMethod
        }
        let parameters = try self.generateParameters(with: requestValues.type, cardEntity: cardEntity)
        let configuration = PLCardsOtherOperativesWebConfiguration(
            initialURL: initialURL,
            bodyParameters: parameters,
            closingURLs: [closingUrl, "app://close"],
            webToolbarTitleKey: " ",
            pdfToolbarTitleKey: " ",
            httpMethod: httpMethodCard,
            isFullScreenEnabled: cardData.isFullScreen)
        return
            UseCaseResponse.ok(GetPLCardsOtherOperativesWebConfigurationUseCaseOkOutput(configuration: configuration))
    }
}

extension GetPLCardsOtherOperativesWebConfigurationUseCase {
    func generateParameters(with type: PLCardWebViewType, cardEntity: CardEntity) throws -> [String: String] {
        var parameters = [String: String]()
        let result = try getContext()
        var ownerId = ""
        switch result {
        case .success(let context):
            parameters["profileId"] = context.profileId
            parameters["clientId"] = "\(context.accessTokenInfo.userId)"
            parameters["access_token"] = context.accessTokenInfo.access_token
            ownerId = context.ownerId
            parameters["mlang"] = getLanguage()
            parameters["oneApp"] = "true"
            if isOwnerIdNeeded(type: type, profileId: context.profileId) {
                parameters["ownerId"] = ownerId
            }
        default:
            break
        }
        return parameters
    }
    
    func getContext() throws -> Result<PLContextDTO, NetworkProviderError> {
        guard let baseUrl = self.getBaseUrl() else {
            return .failure(NetworkProviderError.other)
        }
        let absoluteUrl = baseUrl + "/api/as"
        let serviceName = "/context"
        let result: Result<PLContextDTO, NetworkProviderError> = self.networkProvider.request(PLContextRequest(serviceName: serviceName,
                                                                                                               serviceUrl: absoluteUrl,
                                                                                                               method: .get,
                                                                                                               headers: nil,
                                                                                                               contentType: .urlEncoded,
                                                                                                               localServiceName: .authenticate)
        )
        return result
    }

    func getBaseUrl() -> String? {
        return try? self.dataProvider.getEnvironment().urlBase
    }
    
    private func isOwnerIdNeeded(type: PLCardWebViewType, profileId: String) -> Bool {
        if isSMECustomer(profileId: profileId) || type == .multicurrency {
            return true
        }
        return false
    }

    private func isSMECustomer(profileId: String) -> Bool {
        if profileId == "9" || profileId == "25" {
            return true
        } else {
            return false
        }
    }
    
    private func getLanguage() -> String {
        return dependenciesResolver.resolve(forOptionalType: StringLoader.self)?.getCurrentLanguage().languageType.rawValue ?? "en"
    }
}

struct GetPLCardsOtherOperativesWebConfigurationUseCaseInput {
    let type: PLCardWebViewType
    let cardEntity: CardEntity
    let cardData: PLAccountOtherOperativesData
}

public enum PLCardWebViewType {
    case cancel, multicurrency, pin, useAbroad, changeLimits, viewStatements, enable, repayInInstallments, customerService, atmPackage, alerts24
}

struct GetPLCardsOtherOperativesWebConfigurationUseCaseOkOutput {
    let configuration: WebViewConfiguration
}

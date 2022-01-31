//
//  DataSource.swift
//  PLLegacyAdapter
//
//  Created by Juan Sánchez Marín on 21/9/21.
//

import Foundation

protocol CardDetailDataSourceProtocol {
    func getCardDetail(_ parameters: CardDetailParameters) throws -> Result<CardDetailDTO, NetworkProviderError>
}

private extension CardDetailDataSource {
    func getBaseUrl() -> String? {
        return try? self.dataProvider.getEnvironment().urlBase
    }
}

final class CardDetailDataSource: CardDetailDataSourceProtocol {
    private enum CardDetailServiceType: String {
        case cardDetail = "/cards"
    }

    private let networkProvider: NetworkProvider
    private let dataProvider: BSANDataProvider
    private let basePath = "/api"
    private var headers: [String: String] = [:]
    private var queryParams: [String: Any]? = nil

    init(networkProvider: NetworkProvider, dataProvider: BSANDataProvider) {
        self.networkProvider = networkProvider
        self.dataProvider = dataProvider
    }

    func getCardDetail(_ parameters: CardDetailParameters) throws -> Result<CardDetailDTO, NetworkProviderError> {
        guard let baseUrl = self.getBaseUrl() else {
            return .failure(NetworkProviderError.other)
        }
        self.queryParams = ["includeCreditAccountDetails" : true]

        let absoluteUrl = baseUrl + self.basePath
        let serviceName = CardDetailServiceType.cardDetail.rawValue + "/" + parameters.virtualPan + "?includeCreditAccountDetails=true"
        let result: Result<CardDetailDTO, NetworkProviderError> = self.networkProvider.request(CardDetailRequest(serviceName: serviceName,
                                                                                                                serviceUrl: absoluteUrl,
                                                                                                                method: .get,
                                                                                                                headers: self.headers,
                                                                                                                queryParams: self.queryParams,
                                                                                                                contentType: nil,
                                                                                                                localServiceName: .cardDetail)
        )
        return result
    }
}

private struct CardDetailRequest: NetworkProviderRequest {
    let serviceName: String
    let serviceUrl: String
    let method: NetworkProviderMethod
    let headers: [String: String]?
    let queryParams: [String: Any]?
    let jsonBody: NetworkProviderRequestBodyEmpty? = nil
    let formData: Data?
    let bodyEncoding: NetworkProviderBodyEncoding? = .none
    let contentType: NetworkProviderContentType?
    let localServiceName: PLLocalServiceName
    let authorization: NetworkProviderRequestAuthorization? = .oauth

    init(serviceName: String,
         serviceUrl: String,
         method: NetworkProviderMethod,
         body: Data? = nil,
         jsonBody: Encodable? = nil,
         headers: [String: String]?,
         queryParams: [String: Any]? = nil,
         contentType: NetworkProviderContentType?,
         localServiceName: PLLocalServiceName) {
        self.serviceName = serviceName
        self.serviceUrl = serviceUrl
        self.method = method
        self.formData = body
        self.headers = headers
        self.queryParams = queryParams
        self.contentType = contentType
        self.localServiceName = localServiceName
    }
}

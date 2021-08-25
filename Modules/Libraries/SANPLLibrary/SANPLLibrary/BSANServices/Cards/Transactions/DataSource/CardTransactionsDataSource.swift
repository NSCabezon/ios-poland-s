//
//  CardTransactionsDataSource.swift
//  SANPLLibrary
//
//  Created by Rubén Muñoz López on 13/8/21.
//

import Foundation

// MARK: - CardTransactionsDataSourceProtocol Protocol
protocol CardTransactionsDataSourceProtocol {
    func getCardTransactions(cardId: String, pagination: TransactionsLinksDTO?) -> CardTransactionListDTO?
    func loadCardTransactions(cardId: String, pagination: TransactionsLinksDTO?, filters: String?) -> Result<CardTransactionListDTO, NetworkProviderError>
}

final class CardTransactionsDataSource {

    private let networkProvider: NetworkProvider
    private let dataProvider: BSANDataProvider
    private let basePath = "/api"
    private let serviceNamePath = "/history"
    private let serviceType = "/transactions"
    private let serviceName = "/searchbycard"
    private var queryParms: String?
    
    // MARK: - Initializers

    public init(networkProvider: NetworkProvider, dataProvider: BSANDataProvider) {
        self.networkProvider = networkProvider
        self.dataProvider = dataProvider
    }
}

// MARK: - CardsTransactionsDataSource Private Extension
private extension CardTransactionsDataSource {
    func getBaseUrl() -> String? {
        return try? self.dataProvider.getEnvironment().urlBase
    }
}

// MARK: - CardTransactionsDataSourceProtocol Extension
extension CardTransactionsDataSource: CardTransactionsDataSourceProtocol {
    
    func getCardTransactions(cardId: String, pagination: TransactionsLinksDTO?) -> CardTransactionListDTO? {
        guard let sessionData = try? self.dataProvider.getSessionData() else {
            return nil
        }
        return sessionData.cardsTransactions[cardId]
    }
    
    func loadCardTransactions(cardId: String, pagination: TransactionsLinksDTO?) -> Result<CardTransactionListDTO, NetworkProviderError> {
        guard let baseUrl = getBaseUrl() else { return .failure(NetworkProviderError.other) }
        let absoluteUrl = baseUrl + basePath + serviceNamePath
        
        let parameters = CardTransactionsParameters(cardNo: cardId)
        
        let request = CardTransationsRequest(serviceName: self.serviceName,
                                             serviceUrl: absoluteUrl,
                                             method: .post,
                                             jsonBody: parameters,
                                             headers: nil,
                                             bodyEncoding: .body,
                                             contentType: .json,
                                             localServiceName: .searchbycard)
        let result: Result<CardTransactionListDTO, NetworkProviderError> = self.networkProvider.request(request)
        return result
    }
    
    func loadCardTransactions(cardId: String, pagination: TransactionsLinksDTO?, filters: String?) -> Result<CardTransactionListDTO, NetworkProviderError> {
        guard let baseUrl = getBaseUrl() else { return .failure(NetworkProviderError.other) }
        let absoluteUrl = baseUrl + basePath + serviceNamePath
        
        let parameters = CardTransactionsParameters(cardNo: cardId)
        
        let request = CardTransationsRequest(serviceName: self.serviceName,
                                             serviceUrl: absoluteUrl,
                                             method: .post,
                                             jsonBody: parameters,
                                             headers: nil,
                                             bodyEncoding: .body,
                                             contentType: .json,
                                             localServiceName: .searchbycard)
        let result: Result<CardTransactionListDTO, NetworkProviderError> = self.networkProvider.request(request)
        return result
    }
}

// MARK: - Private Structs
private struct CardTransationsRequest: NetworkProviderRequest {
    let serviceName: String
    let serviceUrl: String
    let method: NetworkProviderMethod
    let headers: [String: String]?
    let queryParams: [String: Any]?
    let jsonBody: CardTransactionsParameters?
    let formData: Data?
    let bodyEncoding: NetworkProviderBodyEncoding?
    let contentType: NetworkProviderContentType
    let localServiceName: PLLocalServiceName
    let authorization: NetworkProviderRequestAuthorization? = .oauth
    
    init(serviceName: String,
         serviceUrl: String,
         method: NetworkProviderMethod,
         body: Data? = nil,
         jsonBody: CardTransactionsParameters? = nil,
         headers: [String: String]?,
         queryParams: [String: Any]? = nil,
         bodyEncoding: NetworkProviderBodyEncoding? = .none,
         contentType: NetworkProviderContentType,
         localServiceName: PLLocalServiceName) {
        self.serviceName = serviceName
        self.serviceUrl = serviceUrl
        self.jsonBody = jsonBody
        self.method = method
        self.formData = body
        self.headers = headers
        self.queryParams = queryParams
        self.bodyEncoding = bodyEncoding
        self.contentType = contentType
        self.localServiceName = localServiceName
    }
}
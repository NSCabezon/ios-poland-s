//
//  CardTransactionsDataSource.swift
//  SANPLLibrary
//
//  Created by Rubén Muñoz López on 13/8/21.
//

import Foundation
import SANLegacyLibrary

// MARK: - CardTransactionsDataSourceProtocol Protocol
protocol CardTransactionsDataSourceProtocol {
    func loadCardTransactions(cardId: String, pagination: TransactionsLinksDTO?, searchTerm: String?, startDate: String?, endDate: String?, fromAmount: Decimal?, toAmount: Decimal?, movementType: String?, cardOperationType: String?) throws -> Result<CardTransactionListDTO, NetworkProviderError>
    func changeAlias(cardDTO: SANLegacyLibrary.CardDTO, newAlias: String) throws -> Result<CardChangeAliasDTO, NetworkProviderError>
}

final class CardTransactionsDataSource {

    private let networkProvider: NetworkProvider
    private let dataProvider: BSANDataProvider
    private let basePath = "/api"
    private let serviceNamePath = "/history"
    private let serviceType = "/transactions"
    private var queryParms: String?

    private enum CardTransactionsServiceType: String {
        case cardTransactions = "/searchbycard"
        case changeAlias = "/accounts/productaliases"
    }
    
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
    
    func getCachedCardTransactions(cardId: String) -> CardTransactionListDTO? {
        guard let sessionData = try? self.dataProvider.getSessionData() else {
            return nil
        }
        return sessionData.cardsTransactions[cardId]
    }
    
    func getCachedCardPagination(cardId: String) -> TransactionsLinksDTO? {
        guard let sessionData = try? self.dataProvider.getSessionData() else {
            return nil
        }
        return sessionData.cardTransactionsPagination[cardId]
    }
    
    func loadCardTransactions(cardId: String, pagination: TransactionsLinksDTO?, searchTerm: String? = nil, startDate: String? = nil, endDate: String? = nil, fromAmount: Decimal? = nil, toAmount: Decimal? = nil, movementType: String? = nil, cardOperationType: String? = nil) throws -> Result<CardTransactionListDTO, NetworkProviderError> {
        guard let baseUrl = getBaseUrl() else { return .failure(NetworkProviderError.other) }
        let absoluteUrl = baseUrl + basePath + serviceNamePath
        
        // Both cardOperation and movementType filters apply to the same parameter in the service (debitFlag)
        // Their functionality is to filter between credit (incomes) and debit operations (expenses)
        // cardOperationType is hidden by default in Poland
        
        let parameters = CardTransactionsParameters(cardNo: cardId, firstOper: "100", text: searchTerm, startDate: startDate, endDate: endDate, amountFrom: fromAmount, amountTo: toAmount, debitFlag: movementType, pagination: pagination)
        
        let serviceName = "\(CardTransactionsServiceType.cardTransactions.rawValue)"
        
        let request = CardTransationsRequest(serviceName: serviceName,
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
    
    func changeAlias(cardDTO: SANLegacyLibrary.CardDTO, newAlias: String) throws -> Result<CardChangeAliasDTO, NetworkProviderError> {
        guard let baseUrl = self.getBaseUrl(),
              let cardNumber = cardDTO.productId?.id,
              let systemId = cardDTO.productId?.systemId else {
            return .failure(NetworkProviderError.other)
        }
        
        let serviceName = "\(CardTransactionsServiceType.changeAlias.rawValue)/\(systemId)/\(cardNumber)"
        let absoluteUrl = baseUrl + self.basePath
        let parameters = ChangeAliasParameters(userDefined: newAlias)
        
        let result: Result<CardChangeAliasDTO, NetworkProviderError> = self.networkProvider.request(CardChangeAliasRequest(serviceName: serviceName,
                                                                                                                serviceUrl: absoluteUrl,
                                                                                                                method: .post,
                                                                                                                jsonBody: parameters,
                                                                                                                headers: nil,
                                                                                                                contentType: .json,
                                                                                                                localServiceName: .changeAlias)
        )
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
    let contentType: NetworkProviderContentType?
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
         contentType: NetworkProviderContentType?,
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

private struct CardChangeAliasRequest: NetworkProviderRequest {
    let serviceName: String
    let serviceUrl: String
    let method: NetworkProviderMethod
    let headers: [String: String]?
    let queryParams: [String: Any]?
    let jsonBody: ChangeAliasParameters?
    let formData: Data?
    let bodyEncoding: NetworkProviderBodyEncoding? = .body
    let contentType: NetworkProviderContentType?
    let localServiceName: PLLocalServiceName
    let authorization: NetworkProviderRequestAuthorization? = .oauth

    init(serviceName: String,
         serviceUrl: String,
         method: NetworkProviderMethod,
         body: Data? = nil,
         jsonBody: ChangeAliasParameters?,
         headers: [String: String]?,
         queryParams: [String: String]? = nil,
         contentType: NetworkProviderContentType?,
         localServiceName: PLLocalServiceName) {
        self.serviceName = serviceName
        self.serviceUrl = serviceUrl
        self.method = method
        self.formData = body
        self.jsonBody = jsonBody
        self.headers = headers
        self.queryParams = queryParams
        self.contentType = contentType
        self.localServiceName = localServiceName
    }
}

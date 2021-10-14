//
//  TransfersDataSource.swift
//  SANPLLibrary
//

import Foundation
import SANLegacyLibrary

protocol TransfersDataSourceProtocol {
    func getAccountsForDebit() throws -> Result<[AccountForDebitDTO], NetworkProviderError>
}

private extension TransfersDataSource {
    func getBaseUrl() -> String? {
        return try? self.dataProvider.getEnvironment().urlBase
    }
}

final class TransfersDataSource {
    private enum TransferServiceType: String {
        case accountForDebit = "/accounts/for-debit"
    }

    private let networkProvider: NetworkProvider
    private let dataProvider: BSANDataProvider
    private let basePath = "/api"
    private var headers: [String: String] = [:]

    init(networkProvider: NetworkProvider, dataProvider: BSANDataProvider) {
        self.networkProvider = networkProvider
        self.dataProvider = dataProvider
    }
}

extension TransfersDataSource: TransfersDataSourceProtocol {
    
    func getAccountsForDebit() throws -> Result<[AccountForDebitDTO], NetworkProviderError> {
        guard let baseUrl = self.getBaseUrl() else {
            return .failure(NetworkProviderError.other)
        }
        let serviceName = TransferServiceType.accountForDebit.rawValue
        let absoluteUrl = baseUrl + self.basePath
        let result: Result<[AccountForDebitDTO], NetworkProviderError> = self.networkProvider.request(AccountRequest(serviceName: serviceName,
                                                                                                                serviceUrl: absoluteUrl,
                                                                                                                method: .get,
                                                                                                                headers: self.headers,
                                                                                                                queryParams: nil,
                                                                                                                contentType: .urlEncoded,
                                                                                                                localServiceName: .accountsForDebit)
        )
        return result
    }
}

private struct AccountRequest: NetworkProviderRequest {
    let serviceName: String
    let serviceUrl: String
    let method: NetworkProviderMethod
    let headers: [String: String]?
    let queryParams: [String: Any]?
    let jsonBody: WithholdingParameters?
    let formData: Data?
    let bodyEncoding: NetworkProviderBodyEncoding?
    let contentType: NetworkProviderContentType
    let localServiceName: PLLocalServiceName
    let authorization: NetworkProviderRequestAuthorization? = .oauth

    init(serviceName: String,
         serviceUrl: String,
         method: NetworkProviderMethod,
         body: Data? = nil,
         jsonBody: WithholdingParameters? = nil,
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
//
//  AccountDataSource.swift
//  SANPLLibrary
//

import Foundation
import SANLegacyLibrary

protocol AccountDataSourceProtocol {
    func getDetails(accountNumber: String, parameters: AccountDetailsParameters) throws -> Result<AccountDetailDTO, NetworkProviderError>
    func getSwiftBranches(accountNumber: String) throws -> Result<SwiftBranchesDTO, NetworkProviderError>
    func getWithholdingList(accountNumbers: [String]) throws -> Result<WithholdingListDTO, NetworkProviderError>
}

private extension AccountDataSource {
    func getBaseUrl() -> String? {
        return try? self.dataProvider.getEnvironment().urlBase
    }
}

final class AccountDataSource {
    private enum AccountServiceType: String {
        case detail = "/accounts"
        case swiftBranches = "/swiftbranches"
        case cardwithholdings = "/history/cardwithholdings"
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
}

extension AccountDataSource: AccountDataSourceProtocol {
    func getDetails(accountNumber: String, parameters: AccountDetailsParameters) throws -> Result<AccountDetailDTO, NetworkProviderError> {
        guard let baseUrl = self.getBaseUrl(),
              let account = try? self.dataProvider.getSessionData().globalPositionDTO?.accounts?.filter({ $0.number == accountNumber }).first,
              let systemId = account.accountId?.systemId else {
            return .failure(NetworkProviderError.other)
        }

        self.queryParams = nil
        if let parametersData = try? JSONEncoder().encode(parameters) {
            self.queryParams = try? JSONSerialization.jsonObject(with: parametersData, options: []) as? [String : Any]
        }

        let serviceName = "\(AccountServiceType.detail.rawValue)/\(accountNumber)/\(systemId)"
        let absoluteUrl = baseUrl + self.basePath
        let result: Result<AccountDetailDTO, NetworkProviderError> = self.networkProvider.request(AccountRequest(serviceName: serviceName,
                                                                                                                serviceUrl: absoluteUrl,
                                                                                                                method: .get,
                                                                                                                headers: self.headers,
                                                                                                                queryParams: self.queryParams,
                                                                                                                contentType: .urlEncoded,
                                                                                                                localServiceName: .accountDetails)
        )
        return result
    }
    
    func getSwiftBranches(accountNumber: String) throws -> Result<SwiftBranchesDTO, NetworkProviderError> {
        guard let baseUrl = self.getBaseUrl() else {
            return .failure(NetworkProviderError.other)
        }
        self.queryParams = nil

        let serviceName = "\(AccountServiceType.swiftBranches.rawValue)/\(accountNumber)"
        let absoluteUrl = baseUrl + self.basePath
        let result: Result<SwiftBranchesDTO, NetworkProviderError> = self.networkProvider.request(AccountRequest(serviceName: serviceName,
                                                                                                                serviceUrl: absoluteUrl,
                                                                                                                method: .get,
                                                                                                                headers: self.headers,
                                                                                                                queryParams: self.queryParams,
                                                                                                                contentType: .urlEncoded,
                                                                                                                localServiceName: .swiftBranches)
        )
        return result
    }
    
    func getWithholdingList(accountNumbers: [String]) throws -> Result<WithholdingListDTO, NetworkProviderError> {
        guard let baseUrl = self.getBaseUrl() else {
            return .failure(NetworkProviderError.other)
        }

        self.queryParams = ["accountNumbers": accountNumbers]

        let serviceName = "\(AccountServiceType.cardwithholdings.rawValue)"
        
        let absoluteUrl = baseUrl + self.basePath
        let result: Result<WithholdingListDTO, NetworkProviderError> = self.networkProvider.request(AccountRequest(serviceName: serviceName,
                                                                                                                serviceUrl: absoluteUrl,
                                                                                                                method: .post,
                                                                                                                headers: self.headers,
                                                                                                                queryParams: self.queryParams,
                                                                                                                contentType: .urlEncoded,
                                                                                                                localServiceName: .cardWithHoldings)
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
    let jsonBody: NetworkProviderRequestBodyEmpty? = nil
    let formData: Data?
    let bodyEncoding: NetworkProviderBodyEncoding? = .none
    let contentType: NetworkProviderContentType
    let localServiceName: PLLocalServiceName
    let authorization: NetworkProviderRequestAuthorization? = .oauth

    init(serviceName: String,
         serviceUrl: String,
         method: NetworkProviderMethod,
         body: Data? = nil,
         jsonBody: Encodable? = nil,
         headers: [String: String]?,
         queryParams: [String: Any]? = nil,
         contentType: NetworkProviderContentType,
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

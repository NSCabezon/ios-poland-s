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
    func getAccountsForDebit(transactionType: Int) throws -> Result<[DebitAccountDTO], NetworkProviderError>
    func loadAccountTransactions(parameters: AccountTransactionsParameters?) throws -> Result<AccountTransactionsDTO, NetworkProviderError>
    func changeAlias(accountDTO: SANLegacyLibrary.AccountDTO, newAlias: String) throws -> Result<AccountChangeAliasDTO, NetworkProviderError>
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
        case transactions = "/history/search"
        case accountForDebit = "/accounts/for-debit"
        case accountForCredit = "/accounts/for-credit"
        case changeAlias = "/accounts/productaliases"
        
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
                                                                                                                contentType: nil,
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
                                                                                                                contentType: nil,
                                                                                                                localServiceName: .swiftBranches)
        )
        return result
    }
    
    func getWithholdingList(accountNumbers: [String]) throws -> Result<WithholdingListDTO, NetworkProviderError> {
        guard let baseUrl = self.getBaseUrl() else {
            return .failure(NetworkProviderError.other)
        }
        
        let parameters = WithholdingParameters(accountNumbers: accountNumbers)
        let serviceName = "\(AccountServiceType.cardwithholdings.rawValue)"
        
        let absoluteUrl = baseUrl + self.basePath
        let result: Result<WithholdingListDTO, NetworkProviderError> = self.networkProvider.request(AccountRequest(serviceName: serviceName,
                                                                                                                serviceUrl: absoluteUrl,
                                                                                                                method: .post,
                                                                                                                jsonBody: parameters,
                                                                                                                headers: self.headers,
                                                                                                                bodyEncoding: .body,
                                                                                                                contentType: .json,
                                                                                                                localServiceName: .cardWithHoldings)
        )
        return result
    }
    
    func getAccountsForDebit(transactionType: Int) throws -> Result<[DebitAccountDTO], NetworkProviderError> {
        guard let baseUrl = self.getBaseUrl() else {
            return .failure(NetworkProviderError.other)
        }

        let serviceName = AccountServiceType.accountForDebit.rawValue + "/\(transactionType)"
        let absoluteUrl = baseUrl + self.basePath
        return networkProvider.request(
            GetAccountsForDebitRequest(serviceName: serviceName,
                                       serviceUrl: absoluteUrl
            )
        )
    }

    func loadAccountTransactions(parameters: AccountTransactionsParameters?) throws -> Result<AccountTransactionsDTO, NetworkProviderError> {
        guard let baseUrl = self.getBaseUrl() else {
            return .failure(NetworkProviderError.other)
        }

        let serviceName = AccountServiceType.transactions.rawValue
        let absoluteUrl = baseUrl + self.basePath
        let result: Result<AccountTransactionsDTO, NetworkProviderError> = self.networkProvider.request(AccountTransactionRequest(serviceName: serviceName,
                                                                                                                serviceUrl: absoluteUrl,
                                                                                                                method: .post,
                                                                                                                jsonBody: parameters,
                                                                                                                headers: self.headers,
                                                                                                                contentType: .json,
                                                                                                                localServiceName: .accountTransactions)
        )
        return result
    }
    
    func changeAlias(accountDTO: SANLegacyLibrary.AccountDTO, newAlias: String) throws -> Result<AccountChangeAliasDTO, NetworkProviderError> {
        guard let baseUrl = self.getBaseUrl(),
              let accountNumber = accountDTO.productId?.id,
              let systemId = accountDTO.productId?.systemId else {
            return .failure(NetworkProviderError.other)
        }

        let serviceName = "\(AccountServiceType.changeAlias.rawValue)/\(systemId)/\(accountNumber)"
        let absoluteUrl = baseUrl + self.basePath
        let parameters = ChangeAliasParameters(userDefined: newAlias)
        
        let result: Result<AccountChangeAliasDTO, NetworkProviderError> = self.networkProvider.request(AccountChangeAliasRequest(serviceName: serviceName,
                                                                                                                serviceUrl: absoluteUrl,
                                                                                                                method: .post,
                                                                                                                jsonBody: parameters,
                                                                                                                headers: self.headers,
                                                                                                                contentType: .json,
                                                                                                                localServiceName: .changeAlias)
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
    let contentType: NetworkProviderContentType?
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

private struct AccountTransactionRequest: NetworkProviderRequest {
    let serviceName: String
    let serviceUrl: String
    let method: NetworkProviderMethod
    let headers: [String: String]?
    let queryParams: [String: Any]?
    let jsonBody: AccountTransactionsParameters?
    let formData: Data?
    let bodyEncoding: NetworkProviderBodyEncoding? = .body
    let contentType: NetworkProviderContentType?
    let localServiceName: PLLocalServiceName
    let authorization: NetworkProviderRequestAuthorization? = .oauth

    init(serviceName: String,
         serviceUrl: String,
         method: NetworkProviderMethod,
         body: Data? = nil,
         jsonBody: AccountTransactionsParameters?,
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

private struct AccountChangeAliasRequest: NetworkProviderRequest {
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

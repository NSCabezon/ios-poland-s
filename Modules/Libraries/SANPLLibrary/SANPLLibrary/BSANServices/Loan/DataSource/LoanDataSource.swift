//
//  LoanDataSource.swift
//  SANPLLibrary
//

import Foundation
import SANLegacyLibrary

protocol LoanDataSourceProtocol {
    func getDetails(accountNumber: String, parameters: LoanDetailsParameters) throws -> Result<LoanDetailDTO, NetworkProviderError>
    func getTransactions(accountNumber: String, parameters: LoanTransactionParameters?) throws -> Result<LoanOperationListDTO, NetworkProviderError>
    func getTransactions(accountId: String, parameters: LoanTransactionParameters?) throws -> Result<LoanOperationListDTO, NetworkProviderError>
    func getInstallments(accountId: String, parameters: LoanInstallmentsParameters?) throws -> Result<LoanInstallmentsListDTO, NetworkProviderError>
	func changeAlias(loanDTO: SANLegacyLibrary.LoanDTO, newAlias: String) throws -> Result<LoanChangeAliasDTO, NetworkProviderError>
}

private extension LoanDataSource {
    func getBaseUrl() -> String? {
        return try? self.dataProvider.getEnvironment().urlBase
    }
}

final class LoanDataSource {
    private enum LoanServiceType: String {
        case detail = "/accounts"
        case transactions = "/history"
        case installments = "/accounts/loan/installments"
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

extension LoanDataSource: LoanDataSourceProtocol {
    func getDetails(accountNumber: String, parameters: LoanDetailsParameters) throws -> Result<LoanDetailDTO, NetworkProviderError> {
        guard let baseUrl = self.getBaseUrl(),
              let loan = try? self.dataProvider.getSessionData().globalPositionDTO?.loans?.filter({ $0.number == accountNumber }).first,
              let systemId = loan.accountId?.systemId else {
            return .failure(NetworkProviderError.other)
        }

        self.queryParams = nil
        if let parametersData = try? JSONEncoder().encode(parameters) {
            self.queryParams = try? JSONSerialization.jsonObject(with: parametersData, options: []) as? [String : Any]
        }

        let serviceName = "\(LoanServiceType.detail.rawValue)/\(accountNumber)/\(systemId)"
        let absoluteUrl = baseUrl + self.basePath
        let result: Result<LoanDetailDTO, NetworkProviderError> = self.networkProvider.request(LoanRequest(serviceName: serviceName,
                                                                                                                serviceUrl: absoluteUrl,
                                                                                                                method: .get,
                                                                                                                headers: self.headers,
                                                                                                                queryParams: self.queryParams,
                                                                                                                contentType: nil,
                                                                                                                localServiceName: .loanDetails)
        )
        return result
    }

    func getTransactions(accountNumber: String, parameters: LoanTransactionParameters?) throws -> Result<LoanOperationListDTO, NetworkProviderError> {
        let result = try self.performGetTransactions(accountId: accountNumber, type: .byNumber, parameters: parameters)
        return result
    }

    func getTransactions(accountId: String, parameters: LoanTransactionParameters?) throws -> Result<LoanOperationListDTO, NetworkProviderError> {
        let result = try self.performGetTransactions(accountId: accountId, type: .byId, parameters: parameters)
        return result
    }

    func getInstallments(accountId: String, parameters: LoanInstallmentsParameters?) throws -> Result<LoanInstallmentsListDTO, NetworkProviderError> {
        guard let baseUrl = self.getBaseUrl() else {
            return .failure(NetworkProviderError.other)
        }

        self.queryParams = nil
        if let parameters = parameters, let parametersData = try? JSONEncoder().encode(parameters) {
            self.queryParams = try? JSONSerialization.jsonObject(with: parametersData, options: []) as? [String : Any]
        }

        let serviceName = "\(LoanServiceType.installments.rawValue)/\(accountId)"
        let absoluteUrl = baseUrl + self.basePath
        let result: Result<LoanInstallmentsListDTO, NetworkProviderError> = self.networkProvider.request(LoanRequest(serviceName: serviceName,
                                                                                                                serviceUrl: absoluteUrl,
                                                                                                                method: .get,
                                                                                                                headers: self.headers,
                                                                                                                queryParams: self.queryParams,
                                                                                                                contentType: nil,
                                                                                                                localServiceName: .loanInstallments)
        )
        return result
    }
	
	func changeAlias(loanDTO: SANLegacyLibrary.LoanDTO, newAlias: String) throws -> Result<LoanChangeAliasDTO, NetworkProviderError> {
		guard let baseUrl = self.getBaseUrl(),
			  let accountNumber = loanDTO.productId?.id,
			  let systemId = loanDTO.productId?.systemId else {
			return .failure(NetworkProviderError.other)
		}

		let serviceName = "\(LoanServiceType.changeAlias.rawValue)/\(systemId)/\(accountNumber)"
		let absoluteUrl = baseUrl + self.basePath
		let parameters = ChangeAliasParameters(userDefined: newAlias)
		
		let result: Result<LoanChangeAliasDTO, NetworkProviderError> = self.networkProvider.request(LoanChangeAliasRequest(serviceName: serviceName,
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

private extension LoanDataSource {
    private func performGetTransactions(accountId: String, type: GetLoanTransactionType, parameters: LoanTransactionParameters?) throws -> Result<LoanOperationListDTO, NetworkProviderError> {
        guard let baseUrl = self.getBaseUrl(),
              let loan = try? self.dataProvider.getSessionData().globalPositionDTO?.loans?.filter({ $0.number == accountId }).first,
              let systemId = loan.accountId?.systemId else {
            return .failure(NetworkProviderError.other)
        }

        self.queryParams = nil
        if let parameters = parameters, let parametersData = try? JSONEncoder().encode(parameters) {
            self.queryParams = try? JSONSerialization.jsonObject(with: parametersData, options: []) as? [String : Any]
        }

        let serviceName = "\(LoanServiceType.transactions.rawValue)/\(type.rawValue)/\(systemId)/\(accountId)"
        let absoluteUrl = baseUrl + self.basePath

        let result: Result<LoanOperationListDTO, NetworkProviderError> = self.networkProvider.request(LoanRequest(serviceName: serviceName,
                                                                                                                serviceUrl: absoluteUrl,
                                                                                                                method: .get,
                                                                                                                headers: self.headers,
                                                                                                                queryParams: self.queryParams,
                                                                                                                contentType: nil,
                                                                                                                localServiceName: .loanTransactions)
        )
        return result
    }
}

private struct LoanRequest: NetworkProviderRequest {
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

private struct LoanChangeAliasRequest: NetworkProviderRequest {
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

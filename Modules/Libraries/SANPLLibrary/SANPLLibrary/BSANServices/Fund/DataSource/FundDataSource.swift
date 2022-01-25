//
//  FundDataSource.swift
//  SANPLLibrary
//
//  Created by Alvaro Royo on 15/1/22.
//

import Foundation
import SANLegacyLibrary

protocol FundDataSourceProtocol {
	func changeAlias(fundDTO: SANLegacyLibrary.FundDTO, newAlias: String) throws -> Result<FundChangeAliasDTO, NetworkProviderError>
}

final class FundDataSource {
	private enum FundServiceType: String {
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

private extension FundDataSource {
	func getBaseUrl() -> String? {
		return try? self.dataProvider.getEnvironment().urlBase
	}
}

extension FundDataSource: FundDataSourceProtocol {
	func changeAlias(fundDTO: SANLegacyLibrary.FundDTO, newAlias: String) throws -> Result<FundChangeAliasDTO, NetworkProviderError> {
		guard let baseUrl = self.getBaseUrl(),
			  let accountNumber = fundDTO.accountId?.id,
			  let systemId = fundDTO.accountId?.systemId else {
			return .failure(NetworkProviderError.other)
		}

		let serviceName = "\(FundServiceType.changeAlias.rawValue)/\(systemId)/\(accountNumber)"
		let absoluteUrl = baseUrl + self.basePath
		let parameters = ChangeAliasParameters(userDefined: newAlias)
		
		let result: Result<FundChangeAliasDTO, NetworkProviderError> = self.networkProvider.request(FundChangeAliasRequest(serviceName: serviceName,
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

private struct FundChangeAliasRequest: NetworkProviderRequest {
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

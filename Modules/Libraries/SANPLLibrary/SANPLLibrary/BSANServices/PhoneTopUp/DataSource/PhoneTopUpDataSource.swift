//
//  PhoneTopUpDataSource.swift
//  SANPLLibrary
//
//  Created by 188216 on 30/11/2021.
//

import Foundation

protocol PhoneTopUpDataSourceProtocol {
    func getPhoneTopUpAccounts() throws -> Result<[DebitAccountDTO], NetworkProviderError>
    func getOperators() throws -> Result<[OperatorDTO], NetworkProviderError>
    func getGSMOperators() throws -> Result<[GSMOperatorDTO], NetworkProviderError>
    func getInternetContacts() throws -> Result<[PayeeDTO], NetworkProviderError>
}

final class PhoneTopUpDataSource {
    
    // MARK: Endpoints
    
    private enum PhoneTopUpServiceType: String {
        case accounts = "/accounts/for-debit/34"
        case operators = "/topup/ws/operators"
        case gsmOperators = "/topup/gsm-operator"
        case internetContacts = "/payees/phone"
    }
    
    // MARK: Properties
    
    private let networkProvider: NetworkProvider
    private let dataProvider: BSANDataProvider
    private let basePath = "/api"
    
    // MARK: Lifecycle
    
    init(networkProvider: NetworkProvider, dataProvider: BSANDataProvider) {
        self.networkProvider = networkProvider
        self.dataProvider = dataProvider
    }
    
    // MARK: Methods
    
    private func getBaseUrl() -> String? {
        return try? self.dataProvider.getEnvironment().urlBase
    }
}

extension PhoneTopUpDataSource: PhoneTopUpDataSourceProtocol {
    func getPhoneTopUpAccounts() throws -> Result<[DebitAccountDTO], NetworkProviderError> {
        guard let baseUrl = self.getBaseUrl() else {
            return .failure(NetworkProviderError.other)
        }
        let serviceUrl = baseUrl + basePath
        let serviceName = PhoneTopUpServiceType.accounts.rawValue
        let request = PhoneTopUpRequest(serviceName: serviceName,
                                        serviceUrl: serviceUrl,
                                        method: .get)
        return networkProvider.request(request)
    }
    
    func getOperators() throws -> Result<[OperatorDTO], NetworkProviderError> {
        guard let baseUrl = self.getBaseUrl() else {
            return .failure(NetworkProviderError.other)
        }
        let serviceUrl = baseUrl + basePath
        let serviceName = PhoneTopUpServiceType.operators.rawValue
        let request = PhoneTopUpRequest(serviceName: serviceName,
                                        serviceUrl: serviceUrl,
                                        method: .get)
        return networkProvider.request(request)
    }
    
    func getGSMOperators() throws -> Result<[GSMOperatorDTO], NetworkProviderError> {
        guard let baseUrl = self.getBaseUrl() else {
            return .failure(NetworkProviderError.other)
        }
        let serviceUrl = baseUrl + basePath
        let serviceName = PhoneTopUpServiceType.gsmOperators.rawValue
        let request = PhoneTopUpRequest(serviceName: serviceName,
                                        serviceUrl: serviceUrl,
                                        method: .get)
        return networkProvider.request(request)
    }
    
    func getInternetContacts() throws -> Result<[PayeeDTO], NetworkProviderError> {
        guard let baseUrl = self.getBaseUrl() else {
            return .failure(NetworkProviderError.other)
        }
        let serviceUrl = baseUrl + basePath
        let serviceName = PhoneTopUpServiceType.internetContacts.rawValue
        let request = PhoneTopUpRequest(serviceName: serviceName,
                                        serviceUrl: serviceUrl,
                                        method: .get)
        return networkProvider.request(request)
    }
}

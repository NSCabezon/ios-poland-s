//
//  SplitPaymentDataSource.swift
//  SplitPayment
//
//  Created by 189501 on 15/03/2022.
//

import Foundation

protocol SplitPaymentDataSourceProtocol {
    func getSplitPaymentsAccounts() throws -> Result<[DebitAccountDTO], NetworkProviderError>
}

final class SplitPaymentDataSource {
    
    // MARK: Endpoints
    
    private enum SplitPaymentServiceType: String {
        case accounts = "/accounts/for-debit/70"
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

extension SplitPaymentDataSource: SplitPaymentDataSourceProtocol {
    func getSplitPaymentsAccounts() throws -> Result<[DebitAccountDTO], NetworkProviderError> {
        guard let baseUrl = self.getBaseUrl() else {
            return .failure(NetworkProviderError.other)
        }
        let serviceUrl = baseUrl + basePath
        let serviceName = SplitPaymentServiceType.accounts.rawValue
        let request = SplitPaymentRequest(serviceName: serviceName,
                                        serviceUrl: serviceUrl,
                                        method: .get,
                                        contentType: nil)
        return networkProvider.request(request)
    }
}


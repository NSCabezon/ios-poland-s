//
//  PLCustomerManager.swift
//  SANPLLibrary
//
//  Created by Ernesto Fernandez Calles on 8/9/21.
//

import Foundation

public protocol PLCustomerManagerProtocol {
    func getIndividual() throws -> Result<CustomerDTO, NetworkProviderError>
}

final class PLCustomerManager {
    private let customerDataSource: CustomerDataSourceProtocol
    private let bsanDataProvider: BSANDataProvider
    private let demoInterpreter: DemoUserProtocol
    
    public init(bsanDataProvider: BSANDataProvider, networkProvider: NetworkProvider, demoInterpreter: DemoUserProtocol) {
        self.customerDataSource = CustomerDataSource(networkProvider: networkProvider, dataProvider: bsanDataProvider)
        self.bsanDataProvider = bsanDataProvider
        self.demoInterpreter = demoInterpreter
    }
}

extension PLCustomerManager: PLCustomerManagerProtocol {
    
    func getIndividual() throws -> Result<CustomerDTO, NetworkProviderError> {
        let result = try self.customerDataSource.getIndividual()
        self.processResult(result)
        return result
    }
}

private extension PLCustomerManager {
    private func processResult(_ result: Result<CustomerDTO, NetworkProviderError>) {
        if case .success(let customer) = result {
            self.bsanDataProvider.storeCustomerIndivual(dto: customer)
        }
    }
}

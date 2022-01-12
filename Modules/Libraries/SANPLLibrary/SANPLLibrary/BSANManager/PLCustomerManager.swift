//
//  PLCustomerManager.swift
//  SANPLLibrary
//
//  Created by Ernesto Fernandez Calles on 8/9/21.
//

import Foundation

public protocol PLCustomerManagerProtocol {
    func getIndividual() throws -> Result<CustomerDTO, NetworkProviderError>
    func putActiveContext(ownerId: String) throws -> Result<Void, NetworkProviderError>
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
        if let cachedIndividual = self.getCachedIndividual() {
            return .success(cachedIndividual)
        }
        let result = try self.customerDataSource.getIndividual()
        self.processIndividualResult(result)
        return result
    }
    
    func putActiveContext(ownerId: String) throws -> Result<Void, NetworkProviderError> {
        let parameters: ActiveContextParameters = ActiveContextParameters(ownerId: ownerId)
        let result = try self.customerDataSource.putActiveContext(parameters)
        return result
    }
}

private extension PLCustomerManager {
    private func getCachedIndividual() -> CustomerDTO? {
        return self.bsanDataProvider.getCustomerIndividual()
    }

    private func processIndividualResult(_ result: Result<CustomerDTO, NetworkProviderError>) {
        if case .success(let customer) = result {
            self.bsanDataProvider.storeCustomerIndivual(dto: customer)
        }
    }
}

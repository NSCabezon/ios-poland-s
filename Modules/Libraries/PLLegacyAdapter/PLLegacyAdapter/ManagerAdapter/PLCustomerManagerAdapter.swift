//
//  PLCustomerManagerAdapter.swift
//  SANPLLibrary
//
//  Created by Ernesto Fernandez Calles on 8/9/21.
//

import SANPLLibrary
import SANLegacyLibrary

final class PLCustomerManagerAdapter {
    
    private let customerManager: PLCustomerManagerProtocol
    private let bsanDataProvider: BSANDataProvider
    
    init(customerManager: PLCustomerManagerProtocol, bsanDataProvider: BSANDataProvider) {
        self.bsanDataProvider = bsanDataProvider
        self.customerManager = customerManager
    }
}

extension PLCustomerManagerAdapter: BSANPersonDataManager  {
    func loadBasicPersonData() throws -> BSANResponse<PersonBasicDataDTO> {
        let customer = try self.customerManager.getIndividual().get()
        let adaptedCustomer = CustomerDTOAdapter.adaptPLCustomer(customer)
        return BSANOkResponse(adaptedCustomer)
    }
    
    func loadPersonDataList(clientDTOs: [ClientDTO]) throws -> BSANResponse<Void> {
        return BSANErrorResponse(nil)

    }
    
    func getPersonData(accountDTO: SANLegacyLibrary.AccountDTO) throws -> BSANResponse<PersonDataDTO> {
        return BSANErrorResponse(nil)
    }
}

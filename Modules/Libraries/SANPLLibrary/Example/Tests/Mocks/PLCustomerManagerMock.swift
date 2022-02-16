//
//  PLCustomerManagerMock.swift
//  SANPLLibrary_Example
//
//  Created by Jose Camallonga on 15/2/22.
//

import Foundation
@testable import SANPLLibrary

struct PLCustomerManagerMock: PLCustomerManagerProtocol {
    func getIndividual() throws -> Result<CustomerDTO, NetworkProviderError> {
        return .success(CustomerDTO(contactData: nil,
                                    address: nil,
                                    correspondenceAddress: nil,
                                    marketingSegment: nil,
                                    cif: nil,
                                    firstName: "Joe",
                                    secondName: nil,
                                    lastName: "Appleseed",
                                    dateOfBirth: nil,
                                    pesel: nil,
                                    citizenship: nil,
                                    customerContexts: nil))
    }
    
    func putActiveContext(ownerId: String) throws -> Result<Void, NetworkProviderError> {
        return .success(())
    }
}

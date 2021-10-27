//
//  PLGlobalPositionManagerAdapter.swift
//  PLLegacyAdapter
//
//  Created by Marcos Álvarez 11/05/2021
//

import SANLegacyLibrary
import SANPLLibrary

final class PLGlobalPositionManagerAdapter {
    
    private let globalPositionManager: PLGlobalPositionManagerProtocol
    private let bsanDataProvider: BSANDataProvider
    private let customerManager: PLCustomerManagerProtocol
    
    init(globalPositionManager: PLGlobalPositionManagerProtocol, bsanDataProvider: BSANDataProvider, customerManager: PLCustomerManagerProtocol) {
        self.bsanDataProvider = bsanDataProvider
        self.globalPositionManager = globalPositionManager
        self.customerManager = customerManager
    }
}

extension PLGlobalPositionManagerAdapter: BSANPGManager {
    func loadGlobalPosition(onlyVisibleProducts: Bool, isPB: Bool) throws -> BSANResponse<SANLegacyLibrary.GlobalPositionDTO> {
        return try getGlobalPosition()
    }
    
    func loadGlobalPositionV2(onlyVisibleProducts: Bool, isPB: Bool) throws -> BSANResponse<SANLegacyLibrary.GlobalPositionDTO> {
        return try getGlobalPosition()
    }
    
    func getGlobalPosition() throws -> BSANResponse<SANLegacyLibrary.GlobalPositionDTO> {
 
        let globalPosition = try self.globalPositionManager.getAllProducts().get()
        guard let authCredentials = try? self.bsanDataProvider.getAuthCredentials() else {
            return BSANErrorResponse(nil)
        }

        let clientPersonCode = String(authCredentials.userId ?? 0)
        var adaptedGlobalPosition = GlobalPositionDTOAdapter.adaptPLGlobalPositionToGlobalPosition(globalPosition, clientPersonCode: clientPersonCode)
        let customer = getCustomer()
        adaptedGlobalPosition.clientName = (customer?.firstName ?? "") + " " + (customer?.lastName ?? "")
        adaptedGlobalPosition.clientNameWithoutSurname =  customer?.firstName
        var secondName = SurNameDTO()
        secondName.surname = customer?.secondName ?? ""
        adaptedGlobalPosition.clientFirstSurname = secondName
        var surname = SurNameDTO()
        surname.surname = customer?.lastName ?? ""
        adaptedGlobalPosition.clientSecondSurname = surname
        return BSANOkResponse(adaptedGlobalPosition)
    }
}

private extension PLGlobalPositionManagerAdapter {
    func getCustomer() -> CustomerDTO? {
        guard let customerPersonalData = try? self.customerManager.getIndividual().get() else {
            return nil
        }
        return customerPersonalData
    }
}

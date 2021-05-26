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
    
    init(globalPositionManager: PLGlobalPositionManagerProtocol, bsanDataProvider: BSANDataProvider) {
        self.bsanDataProvider = bsanDataProvider
        self.globalPositionManager = globalPositionManager
    }
}

extension PLGlobalPositionManagerAdapter: BSANPGManager {
    func loadGlobalPosition(onlyVisibleProducts: Bool, isPB: Bool) throws -> BSANResponse<SANLegacyLibrary.GlobalPositionDTO> {
        return BSANErrorResponse(nil)
    }
    
    func loadGlobalPositionV2(onlyVisibleProducts: Bool, isPB: Bool) throws -> BSANResponse<SANLegacyLibrary.GlobalPositionDTO> {
        return BSANErrorResponse(nil)
    }
    
    func getGlobalPosition() throws -> BSANResponse<SANLegacyLibrary.GlobalPositionDTO> {
 
        let globalPosition = try self.globalPositionManager.getAllProducts()
        
        let adaptedGlobalPosition = GlobalPositionDTOAdapter.adaptPLGlobalPositionToGlobalPosition(try globalPosition.get())
        return BSANOkResponse(adaptedGlobalPosition)
    }
}

//
//  PLManagersManagerAdapter.swift
//  PLLegacyAdapter
//
//  Created by Marcos Álvarez 11/05/2021
//

import SANLegacyLibrary

final class PLManagersManagerAdapter {}
 
extension PLManagersManagerAdapter: BSANManagersManager {
    func getManagers() throws -> BSANResponse<YourManagersListDTO> {
        return BSANOkResponse(YourManagersListDTO())
    }
    
    func loadManagers() throws -> BSANResponse<YourManagersListDTO> {
        return BSANOkResponse(YourManagersListDTO())
    }
    
    func loadClick2Call() throws -> BSANResponse<Click2CallDTO> {
        return BSANErrorResponse(nil)
    }
    
    func loadClick2Call(_ reason: String?) throws -> BSANResponse<Click2CallDTO> {
        return BSANErrorResponse(nil)
    }
    
}

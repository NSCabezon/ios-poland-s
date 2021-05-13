//
//  PLSociusManagerAdapter.swift
//  PLLegacyAdapter
//
//  Created by Marcos Álvarez 11/05/2021
//

import SANLegacyLibrary

final class PLSociusManagerAdapter {
}
 
extension PLSociusManagerAdapter: BSANSociusManager {
    func getSociusAccounts() throws -> BSANResponse<[SociusAccountDTO]> {
        return BSANErrorResponse(nil)
    }
    
    func getSociusLiquidation() throws -> BSANResponse<SociusLiquidationDTO> {
        return BSANErrorResponse(nil)
    }
    
    func loadSociusDetailAccountsAll() throws -> BSANResponse<SociusAccountDetailDTO> {
        return BSANErrorResponse(nil)
    }
    
}

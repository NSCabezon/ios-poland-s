//
//  PLFavouriteTransfersManagerAdapter.swift
//  PLLegacyAdapter
//
//  Created by Marcos Álvarez 11/05/2021
//

import SANLegacyLibrary

final class PLFavouriteTransfersManagerAdapter {}

extension PLFavouriteTransfersManagerAdapter: BSANFavouriteTransfersManager {
    func getFavouriteTransfers() throws -> BSANResponse<[SANLegacyLibrary.PayeeDTO]> {
        return BSANErrorResponse(nil)
    }
    
    func getLocalFavouriteTransfers() throws -> BSANResponse<[SANLegacyLibrary.PayeeDTO]> {
        return BSANErrorResponse(nil)
    }
}

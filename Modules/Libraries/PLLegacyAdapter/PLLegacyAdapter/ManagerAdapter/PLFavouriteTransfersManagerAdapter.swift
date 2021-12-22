//
//  PLFavouriteTransfersManagerAdapter.swift
//  PLLegacyAdapter
//
//  Created by Marcos Álvarez 11/05/2021
//

import SANLegacyLibrary

final class PLFavouriteTransfersManagerAdapter {}

extension PLFavouriteTransfersManagerAdapter: BSANFavouriteTransfersManager {
    func getFavourites() throws -> BSANResponse<[SANLegacyLibrary.PayeeDTO]> {
        return BSANErrorResponse(nil)
    }
    
    func getLocalFavourites() throws -> BSANResponse<[SANLegacyLibrary.PayeeDTO]> {
        return BSANErrorResponse(nil)
    }
}

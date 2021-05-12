//
//  PLAviosManagerAdapter.swift
//  PLLegacyAdapter
//
//  Created by Marcos Álvarez 11/05/2021
//

import SANLegacyLibrary

final class PLAviosManagerAdapter {}
 
extension PLAviosManagerAdapter: BSANAviosManager {
    func getAviosDetail() throws -> BSANResponse<AviosDetailDTO> {
        return BSANErrorResponse(nil)
    }
}

//
//  PLTouchIdManagerAdapter.swift
//  PLLegacyAdapter
//
//  Created by Marcos Álvarez 11/05/2021
//

import SANLegacyLibrary

final class PLTouchIdManagerAdapter {}
 
extension PLTouchIdManagerAdapter: BSANTouchIdManager {
    func registerTouchId(footPrint: String, deviceName: String) throws -> BSANResponse<TouchIdRegisterDTO> {
        return BSANErrorResponse(nil)
    }
}

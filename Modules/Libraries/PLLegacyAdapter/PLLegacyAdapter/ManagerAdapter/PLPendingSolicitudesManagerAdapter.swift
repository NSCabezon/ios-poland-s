//
//  PLPendingSolicitudesManagerAdapter.swift
//  PLLegacyAdapter
//
//  Created by Marcos Álvarez 11/05/2021
//

import Foundation
import SANLegacyLibrary

final class PLPendingSolicitudesManagerAdapter {}
 
extension PLPendingSolicitudesManagerAdapter: BSANPendingSolicitudesManager {
    func getPendingSolicitudes() throws -> BSANResponse<PendingSolicitudeListDTO> {
        return BSANErrorResponse(nil)
    }
    
    func removePendingSolicitudes() {}
}

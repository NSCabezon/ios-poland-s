//
//  PLLastLogonManagerAdapter.swift
//  PLLegacyAdapter
//
//  Created by Marcos Álvarez 11/05/2021
//

import Foundation
import SANLegacyLibrary

final class PLLastLogonManagerAdapter {}
 
extension PLLastLogonManagerAdapter: BSANLastLogonManager {
    func insertDateUpdate() throws -> BSANResponse<Void> {
        return BSANErrorResponse(nil)
    }
    
    func getLastLogonInfo() throws -> BSANResponse<LastLogonDTO> {
        return BSANErrorResponse(nil)
    }
}

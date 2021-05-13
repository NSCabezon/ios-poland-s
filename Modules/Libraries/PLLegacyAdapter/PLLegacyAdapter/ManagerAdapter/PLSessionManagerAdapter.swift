//
//  PLSessionManagerAdapter.swift
//  PLLegacyAdapter
//
//  Created by Marcos Álvarez 11/05/2021
//

import SANLegacyLibrary

final class PLSessionManagerAdapter {}
 
extension PLSessionManagerAdapter: BSANSessionManager {
    func isDemo() throws -> BSANResponse<Bool> {
        return BSANOkResponse(false)
    }
    
    func isPB() throws -> BSANResponse<Bool> {
        return BSANOkResponse(false)
    }
    
    func logout() -> BSANResponse<Void> {
        return BSANOkEmptyResponse()
    }
    
    func getUser() throws -> BSANResponse<SANLegacyLibrary.UserDTO> {
        return BSANErrorResponse(nil)
    }
    
    func cleanSessionData() throws {
    }
}

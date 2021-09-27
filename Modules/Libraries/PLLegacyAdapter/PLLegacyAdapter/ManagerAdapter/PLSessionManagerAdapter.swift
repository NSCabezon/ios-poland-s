//
//  PLSessionManagerAdapter.swift
//  PLLegacyAdapter
//
//  Created by Marcos Álvarez 11/05/2021
//

import SANLegacyLibrary
import SANPLLibrary

final class PLSessionManagerAdapter {
    private let bsanDataProvider: BSANDataProvider

    public init(bsanDataProvider: BSANDataProvider) {
        self.bsanDataProvider = bsanDataProvider
    }
}
 
extension PLSessionManagerAdapter: BSANSessionManager {
    func isDemo() throws -> BSANResponse<Bool> {
        return BSANOkResponse(false)
    }
    
    func isPB() throws -> BSANResponse<Bool> {
        return BSANOkResponse(false)
    }
    
    func logout() -> BSANResponse<Void> {
        self.bsanDataProvider.closeSession()
        return BSANOkEmptyResponse()
    }
    
    func getUser() throws -> BSANResponse<SANLegacyLibrary.UserDTO> {
        return BSANErrorResponse(nil)
    }
    
    func cleanSessionData() throws {
        try self.bsanDataProvider.cleanSessionData()
    }
}

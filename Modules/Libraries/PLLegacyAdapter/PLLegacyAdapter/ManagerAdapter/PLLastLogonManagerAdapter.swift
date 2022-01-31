//
//  PLLastLogonManagerAdapter.swift
//  PLLegacyAdapter
//
//  Created by Marcos Álvarez 11/05/2021
//

import Foundation
import SANLegacyLibrary
import SANPLLibrary
import Commons

final class PLLastLogonManagerAdapter {
    private let loginManager: PLLoginManagerProtocol
    private let bsanDataProvider: BSANDataProvider

    init(loginManager: PLLoginManagerProtocol, bsanDataProvider: BSANDataProvider) {
        self.bsanDataProvider = bsanDataProvider
        self.loginManager = loginManager
    }
}
 
extension PLLastLogonManagerAdapter: BSANLastLogonManager {
    func insertDateUpdate() throws -> BSANResponse<Void> {
        return BSANErrorResponse(nil)
    }
    
    func getLastLogonInfo() throws -> BSANResponse<LastLogonDTO> {
        let loginInfo = try self.loginManager.getLoginInfo().get()
        var lastLogon = LastLogonDTO()
        lastLogon.lastConnection = dateToString(input: loginInfo.lastLogin, inputFormat: .yyyy_MM_ddTHHmmssSSSSSS, outputFormat: .yyyyMMddHHmmss)
        return BSANOkResponse(lastLogon)
    }
}

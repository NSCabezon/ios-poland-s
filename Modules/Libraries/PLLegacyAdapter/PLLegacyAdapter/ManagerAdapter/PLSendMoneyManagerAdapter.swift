//
//  PLSendMoneyManagerAdapter.swift
//  PLLegacyAdapter
//
//  Created by Marcos Álvarez 11/05/2021
//

import SANLegacyLibrary

public class PLSendMoneyManagerAdapter {}

extension PLSendMoneyManagerAdapter: BSANSendMoneyManager {
    public func getCMPSStatus() throws -> BSANResponse<CMPSDTO> {
        return BSANErrorResponse(nil)
    }
    
    public func loadCMPSStatus() throws -> BSANResponse<CMPSDTO> {
        return BSANErrorResponse(nil)
    }
}

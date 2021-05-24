//
//  PLFintechManagerAdapter.swift
//  PLLegacyAdapter
//
//  Created by Francisco del Real Escudero on 20/5/21.
//

import SANLegacyLibrary

final class PLFintechManagerAdapter {}

extension PLFintechManagerAdapter: BSANFintechManager {
    func confirmWithAccessKey(authenticationParams: FintechUserAuthenticationInputParams, userInfo: FintechUserInfoAccessKeyParams) throws -> BSANResponse<FintechAccessConfimationResponseDTO> {
        return BSANErrorResponse(nil)
    }
    
    func confirmWithFootprint(authenticationParams: FintechUserAuthenticationInputParams, userInfo: FintechUserInfoFootprintParams) throws -> BSANResponse<FintechAccessConfimationResponseDTO> {
        return BSANErrorResponse(nil)
    }
}

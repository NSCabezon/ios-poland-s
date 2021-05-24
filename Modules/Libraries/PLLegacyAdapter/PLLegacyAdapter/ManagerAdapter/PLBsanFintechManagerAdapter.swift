//
//  PLBsanFintechManagerAdapter.swift
//  PLLegacyAdapter

import SANLegacyLibrary

final class PLBsanFintechManagerAdapter {}

extension PLBsanFintechManagerAdapter: BSANFintechManager {

    public func confirmWithAccessKey(authenticationParams: FintechUserAuthenticationInputParams, userInfo: FintechUserInfoAccessKeyParams) throws -> BSANResponse<FintechAccessConfimationResponseDTO> {
        return BSANResponse()
    }

    public func confirmWithFootprint(authenticationParams: FintechUserAuthenticationInputParams, userInfo: FintechUserInfoFootprintParams) throws -> BSANResponse<FintechAccessConfimationResponseDTO> {
        return BSANResponse()
    }
}

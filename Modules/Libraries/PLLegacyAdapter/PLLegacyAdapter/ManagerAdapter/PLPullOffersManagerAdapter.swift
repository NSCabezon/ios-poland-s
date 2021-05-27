//
//  PLPullOffersManagerAdapter.swift
//  PLLegacyAdapter
//
//  Created by Marcos Álvarez 11/05/2021
//

import SANLegacyLibrary

final class PLPullOffersManagerAdapter {}

extension PLPullOffersManagerAdapter: BSANPullOffersManager {

    public func getCampaigns() throws -> BSANResponse<[String]?> {
        return BSANOkResponse([])
    }

    public func loadCampaigns() throws -> BSANResponse<Void> {
        return BSANOkResponse(())
    }
}

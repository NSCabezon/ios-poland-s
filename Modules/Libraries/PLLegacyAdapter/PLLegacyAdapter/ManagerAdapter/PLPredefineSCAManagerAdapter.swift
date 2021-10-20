//
//  PLPredefineSCAManagerAdapter.swift
//  PLLegacyAdapter
//
//  Created by Marcos Álvarez 11/05/2021
//

import SANLegacyLibrary

final class PLPredefineSCAManagerAdapter {}

extension PLPredefineSCAManagerAdapter: BSANPredefineSCAManager {
    func getCardBlockPredefinedSCA() -> BSANResponse<PredefinedSCARepresentable> {
        return BSANErrorResponse(nil)
    }
    
    func getInternalTransferPredefinedSCA() -> BSANResponse<PredefinedSCARepresentable> {
        return BSANErrorResponse(nil)
    }
    
    func getOnePayTransferPredefinedSCA() -> BSANResponse<PredefinedSCARepresentable> {
        return BSANErrorResponse(nil)
    }

    func getCVVQueryPredefinedSCA() -> BSANResponse<PredefinedSCARepresentable> {
        return BSANErrorResponse(nil)
    }
    func getCardOnOffPredefinedSCA() -> BSANResponse<PredefinedSCARepresentable> {
        return BSANErrorResponse(nil)
    }
}

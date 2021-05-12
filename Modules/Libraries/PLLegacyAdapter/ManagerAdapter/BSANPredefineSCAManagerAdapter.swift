//
//  PLPredefineSCAManagerAdapter.swift
//  PLLegacyAdapter
//
//  Created by Marcos Álvarez 11/05/2021
//

import SANLegacyLibrary

final class PLPredefineSCAManagerAdapter {}

extension PLPredefineSCAManagerAdapter: BSANPredefineSCAManager {
    func getInternalTransferPredefinedSCA() -> BSANResponse<PredefinedSCARepresentable> {
        return BSANErrorResponse(nil)
    }
}

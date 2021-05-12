//
//  PLTimeLineManagerAdapter.swift
//  PLLegacyAdapter
//
//  Created by Marcos Álvarez 11/05/2021
//

import SANLegacyLibrary

final class PLTimeLineManagerAdapter {}
 
extension PLTimeLineManagerAdapter: BSANTimeLineManager {
    func getMovements(_ input: TimeLineMovementsParameters) throws -> BSANResponse<TimeLineResponseDTO> {
        return BSANErrorResponse(nil)
    }
}

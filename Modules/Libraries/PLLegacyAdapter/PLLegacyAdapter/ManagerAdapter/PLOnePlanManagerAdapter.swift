//
//  PLOnePlanManagerAdapter.swift
//  PLLegacyAdapter
//
//  Created by Marcos Álvarez 11/05/2021
//

import SANLegacyLibrary

final class PLOnePlanManagerAdapter {}
 
extension PLOnePlanManagerAdapter: BSANOnePlanManager {
    func checkOnePlan(ranges: [ProductOneRangeDTO]) throws -> BSANResponse<CustomerContractListDTO> {
        return BSANErrorResponse(nil)
    }
}

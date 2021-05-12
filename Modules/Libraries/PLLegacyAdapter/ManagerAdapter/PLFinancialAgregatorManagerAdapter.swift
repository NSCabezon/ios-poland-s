//
//  PLFinancialAgregatorManagerAdapter.swift
//  PLLegacyAdapter
//
//  Created by Marcos Álvarez 11/05/2021
//

import SANLegacyLibrary

final class PLFinancialAgregatorManagerAdapter {}
 
extension PLFinancialAgregatorManagerAdapter: BSANFinancialAgregatorManager {
    func getFinancialAgregator(_ input: FinancialAgregatorRequestParameters) throws -> BSANResponse<FinancialAgregatorDTO> {
        return BSANErrorResponse(nil)
    }
}

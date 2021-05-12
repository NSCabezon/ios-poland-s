//
//  PLBranchLocatorManagerAdapter.swift
//  PLLegacyAdapter
//
//  Created by Marcos Álvarez 11/05/2021
//

import SANLegacyLibrary

final class PLBranchLocatorManagerAdapter {}
 
extension PLBranchLocatorManagerAdapter: BSANBranchLocatorManager {
    func getNearATMs(_ input: BranchLocatorATMParameters) throws -> BSANResponse<[BranchLocatorATMDTO]> {
        return BSANErrorResponse(nil)
    }
    
    func getEnrichedATM(_ input: BranchLocatorEnrichedATMParameters) throws -> BSANResponse<[BranchLocatorATMEnrichedDTO]> {
        return BSANErrorResponse(nil)
    }
}

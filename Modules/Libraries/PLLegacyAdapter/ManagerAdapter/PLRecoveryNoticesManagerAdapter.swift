//
//  PLRecoveryNoticesManagerAdapter.swift
//  PLLegacyAdapter
//
//  Created by Marcos Álvarez 11/05/2021
//

import SANLegacyLibrary

final class PLRecoveryNoticesManagerAdapter {}
 
extension PLRecoveryNoticesManagerAdapter: BSANRecoveryNoticesManager {
    func getRecoveryNotices() throws -> BSANResponse<[RecoveryDTO]> {
        return BSANErrorResponse(nil)
    }
}

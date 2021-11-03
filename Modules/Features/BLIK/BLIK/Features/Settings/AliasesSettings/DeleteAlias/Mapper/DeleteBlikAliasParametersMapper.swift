//
//  DeleteBlikAliasRequestDTOMapper.swift
//  BLIK
//
//  Created by Piotr Mielcarzewicz on 07/09/2021.
//

import SANPLLibrary

protocol DeleteBlikAliasParametersMapping {
    func map(_ request: DeleteAliasRequest) -> DeleteBlikAliasParameters
}

final class DeleteBlikAliasParametersMapper: DeleteBlikAliasParametersMapping {
    func map(_ request: DeleteAliasRequest) -> DeleteBlikAliasParameters {
        return DeleteBlikAliasParameters(
            aliasValueType: getAliasType(from: request.alias),
            alias: request.alias.alias,
            acquirerId: request.alias.acquirerId,
            merchantId: request.alias.merchantId,
            unregisterReason: getUnregisterReason(from: request.deletionReason)
        )
    }
    
    private func getAliasType(from alias: BlikAlias) -> BlikAliasDTO.AliasType {
        switch alias.type {
        case .mobileDevice:
            return .mobileDevice
        case .internetBrowser:
            return .internetBrowser
        case .internetShop:
            return .internetShop
        case .contactlessHCE:
            return .contactlessHCE
        }
    }
    
    private func getUnregisterReason(
        from reason: DeleteAliasReason
    ) -> DeleteBlikAliasParameters.UnregisterReason? {
        switch reason {
        case .someoneDidPerformFraudTransactionWithAlias:
            return .someoneDidPerformFraudTransactionWithAlias
        case .unknown:
            return nil
        }
    }
}

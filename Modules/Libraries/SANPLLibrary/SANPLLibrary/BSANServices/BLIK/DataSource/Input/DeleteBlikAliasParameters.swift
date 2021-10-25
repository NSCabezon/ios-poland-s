//
//  DeleteBlikAliasParameters.swift
//  SANPLLibrary
//
//  Created by Piotr Mielcarzewicz on 07/09/2021.
//

public struct DeleteBlikAliasParameters: Encodable {
    public let aliasValueType: BlikAliasDTO.AliasType
    public let alias: String
    public let acquirerId: Int?
    public let merchantId: String?
    public let unregisterReason: UnregisterReason?
    
    public init(
        aliasValueType: BlikAliasDTO.AliasType,
        alias: String,
        acquirerId: Int?,
        merchantId: String?,
        unregisterReason: UnregisterReason?
    ) {
        self.aliasValueType = aliasValueType
        self.alias = alias
        self.acquirerId = acquirerId
        self.merchantId = merchantId
        self.unregisterReason = unregisterReason
    }
    
    public enum UnregisterReason: String, Codable {
        case someoneDidPerformFraudTransactionWithAlias = "FRAUD"
    }
}

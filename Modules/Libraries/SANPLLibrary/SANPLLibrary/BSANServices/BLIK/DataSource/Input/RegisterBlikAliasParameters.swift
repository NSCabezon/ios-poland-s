//
//  RegisterBlikAliasParameters.swift
//  SANPLLibrary
//
//  Created by Piotr Mielcarzewicz on 13/09/2021.
//

public struct RegisterBlikAliasParameters: Encodable {
    public let aliasLabel: String
    public let aliasValueType: String
    public let alias: String
    public let acquirerId: Int?
    public let merchantId: String?
    public let expirationDate: String
    public let aliasURL: String?
    public let platform: String?
    public let registerInPSP: Bool
    
    public init(
        aliasLabel: String,
        aliasValueType: String,
        alias: String,
        acquirerId: Int?,
        merchantId: String?,
        expirationDate: String,
        aliasURL: String?,
        platform: String?,
        registerInPSP: Bool
    ) {
        self.aliasLabel = aliasLabel
        self.aliasValueType = aliasValueType
        self.alias = alias
        self.acquirerId = acquirerId
        self.merchantId = merchantId
        self.expirationDate = expirationDate
        self.aliasURL = aliasURL
        self.platform = platform
        self.registerInPSP = registerInPSP
    }
}


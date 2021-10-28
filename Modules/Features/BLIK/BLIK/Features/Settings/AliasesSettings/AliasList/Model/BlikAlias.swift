//
//  BlikAlias.swift
//  BLIK
//
//  Created by Piotr Mielcarzewicz on 02/09/2021.
//

public struct BlikAlias {
    public let walletId: Int
    public let label: String
    public let type: AliasType
    public let alias: String
    public let acquirerId: Int?
    public let merchantId: String?
    public let expirationDate: Date
    public let proposalDate: Date?
    public let status: Int
    public let aliasUsage: String?
    
    public enum AliasType: String {
        case mobileDevice
        case internetShop
        case internetBrowser
        case contactlessHCE
    }
}

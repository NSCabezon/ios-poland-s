//
//  BlikAliasDTO.swift
//  SANPLLibrary
//
//  Created by Piotr Mielcarzewicz on 02/09/2021.
//

public struct BlikAliasDTO: Codable {
    public let walletId: Int
    public let aliasLabel: String
    public let aliasValueType: AliasType
    public let alias: String
    public let acquirerId: Int?
    public let merchantId: String?
    public let expirationDate: String?
    public let proposalDate: String?
    public let status: Int
    public let aliasUsage: String?
    
    public enum AliasType: String, Codable {
        case mobileDevice = "MD"
        case internetShop = "UID"
        case internetBrowser = "COOKIE"
        case contactlessHCE = "HCE"
    }
}

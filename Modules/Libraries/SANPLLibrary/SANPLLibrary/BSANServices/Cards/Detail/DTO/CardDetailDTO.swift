//
//  CardDetailDTO.swift
//  PLLegacyAdapter
//
//  Created by Juan Sánchez Marín on 21/9/21.
//

import Foundation

public struct CardDetailDTO: Codable {
    public let relatedAccountData: RelatedAccountDataDTO?
    public let virtualPan: String?
    public let maskedPan: String?
    public let cardExpirationDate: String?
    public let emboss1: String
    public let emboss2: String
    public let generalStatus: String?
    public let alias: String?
    public let insuranceFlag: Bool?
}

public struct RelatedAccountDataDTO: Codable {
    public let accountNo: String?
    public let creditLimit: BalanceDTO?
    public let balance: BalanceDTO?
    public let availableFunds: BalanceDTO?
}

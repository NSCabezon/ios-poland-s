//
//  SavingDetailsDTO.swift
//  SANPLLibrary
//
//  Created by Marcos Álvarez Mesa on 30/4/22.
//

import Foundation

public struct SavingDetailsFundsDTO: Codable {
    public let calculateDay: String?
    public let bonusInterestRate: Decimal?
    public let assetsBalance: Decimal?
    public let bonusBalance: Decimal?
    public let newFundsBalance: Decimal?
}

public struct SavingDetailsDTO: Codable {
    public let accountNo: String?
    public let productPromotionId: String?
    public let bonusDescription: String?
    public let bonusStatus: String?
    public let bonusCategory: String?
    public let productId: String?
    public let promoCodeRequired: Bool?
    public let bonusCalculationMethod: String?
    public let bonusId: String?
    public let fundsDetails: SavingDetailsFundsDTO?
}

public enum SavingBonusCategory: String {
    case interesRates = "INTEREST_RATES"
}

public enum SavingBonusStatus: String {
    case active = "ACTIVE"
    case postentiallyAvailable = "POTENTIALLY_AVAILABLE"
}

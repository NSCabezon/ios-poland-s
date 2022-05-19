//
//  SavingDTO.swift
//  SANPLLibrary
//
//  Created by Marcos Álvarez Mesa on 29/3/22.
//

public struct SavingDTO: Codable {

    public struct SavingAccountIdDTO: Codable {
        public let id: String?
        public let systemId: Int?
    }

    public struct SavingNameDTO: Codable {
        public let description: String?
        public let userDefined: String?
    }

    public struct InsterestRateDTO: Codable {
        public let interestRate: Decimal
        public let interestRateURL: String?
        public let interestRateIndicator: InterestRateIndicatorTypeDTO?
    }

    public enum InterestRateIndicatorTypeDTO: String, Codable {
        case url = "URL"
        case value = "VALUE"
    }

    public struct SavingBalanceDTO: Codable {
        public let value: Decimal?
        public let currencyCode: String?
        public let valueInBaseCurrency: Decimal?
    }

    public enum SavingRoleDTO: String, Codable {
        case owner = "OWNER"
        case coOwner = "CO_OWNER"
        case warrantor = "WARRANTOR"
        case plenipotentiary = "PLENIPOTENTIARY"
        case notOwner = "NOT_OWNER"
    }

    public let number: String
    public let accountId: SavingAccountIdDTO?
    public let productId: SavingAccountIdDTO?
    public let currencyCode: String?
    public let name: SavingNameDTO?
    public let role: String?
    public let permissionList: [String]?
    public let type: String?
    public let currentBalance: SavingBalanceDTO?
    public let lastUpdate: String?
    public let interestRateData: InsterestRateDTO?
    public let percentageCompletion: Decimal?
}


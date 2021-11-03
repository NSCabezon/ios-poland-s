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
    public let cardStatus: String?
    public let cardProductName: String?
    public let cifNumber: Int?
    public let cardLimitAmount: BalanceDTO?
    public let cardLimitPeriod: Int?
    public let limitType: Int?
    public let cardLimitRemaining: BalanceDTO?
    public let cardAgreementFlag: String?
    public let cardLimitsFlag: Int?
    public let cardOwner: String?
    public let type: String?
    public let bin: String?
    public let icbsProductType: String?
    public let productCode: String?
    public let isHCE: Int?
    public let psAvailability: String?
    public let voAvailability: String?
    public let walletAllowed: Bool?
    public let productionDate: String?
    public let renewCount: Int?
    public let productType: String?
    public let statusDetails: StatusDetailsDTO?
    public let creditCardAccountDetails: CreditCardDetailsDTO?
    public let userCorrespondenceAddress: UserCorrespondenceAddressDTO?
    public let options3DSecure: Options3DSecureDTO?
}

public struct RelatedAccountDataDTO: Codable {
    public let accountId: Int?
    public let accountNo: String?
    public let accountDescription: String?
    public let creditLimit: BalanceDTO?
    public let balance: BalanceDTO?
    public let availableFunds: BalanceDTO?
    public let withholdingBalance: BalanceDTO?
}

public struct StatusDetailsDTO: Codable {
    public let statusDate: String?
    public let statusDescription: String?
    public let statusTechnicalDescription: String?
}

public struct CreditCardDetailsDTO: Codable {
    public let currency: String?
    public let creditCardAccountNo: String?
    public let interestRate: Float?
    public let withholdingBalance: BalanceDTO?
    public let lastStatementDate: String?
    public let nextStatementDate: String?
    public let paymentDate: String?
    public let totalPaymentAmount: BalanceDTO?
    public let minimalPaymentAmount: BalanceDTO?
    public let interestForPreviousPeriod: BalanceDTO?
    public let outstandingMinimumDueAmount: BalanceDTO?
    public let currentMinimumDueAmount: BalanceDTO?
    public let minimumRepaymentAmount: BalanceDTO?
    public let totalRepaymentAmount: BalanceDTO?
    public let creditLimit: BalanceDTO?
}

public struct UserCorrespondenceAddressDTO: Codable {
    public let firstName: String?
    public let lastName: String?
    public let streetHouseFlatNumber: String?
    public let postCode: String?
    public let city: String?
}

public struct Options3DSecureDTO: Codable {
    public let phoneNumber: String?
    public let enabled: Bool?
}

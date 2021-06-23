//
//  LoanDetailDTO.swift
//  SANPLLibrary
//

import Foundation

public struct LoanDetailDTO: Codable {
    public let number: String?
    public let id: String?
    public let taxAccountId: String?
    public let currencyCode: String?
    public let name: LoanNameDTO?
    public let type: String?
    public let balance: BalanceDTO?
    public let availableFunds: BalanceDTO?
    public let lastUpdate: String?
    public let systemId: Int?
    public let permissions: [String]?
    public let defaultForPayments: Bool?
    public let role: String?
    public let functionalities: [String]?
    public let accountDetails: AccountDetailsDTO?
    public let loanAccountDetails: LoanAccountDetailsDTO?
}

public struct AccountDetailsDTO: Codable {
    public let openedDate: String?
    public let interestRate: Double?
}

public struct LoanAccountDetailsDTO: Codable {
    public let loanType: String?
    public let creditTypeName: String?
    public let interest: LoanInterestDetailsDTO?
    public let grantedCreditLimit: BalanceDTO?
    public let finalRepaymentDate: String?
    public let nextInstallmentDate: String?
    public let excessPaymentAmount: BalanceDTO?
    public let excessPaymentFlag: Bool?
}

public struct LoanInterestDetailsDTO: Codable {
    public let rateName: String?
    public let rate: Double?
    public let period: Int?
    public let periodUnit: String?
    public let nextChargingDate: String?
    public let nextExpectDate: String?
    public let totalPaid: BalanceDTO?
    public let previousExpectDate: String?
    public let previousTotalAmount: BalanceDTO?
    public let penaltyAmount: BalanceDTO?
}

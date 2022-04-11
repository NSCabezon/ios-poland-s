//
//  LoanDetailDTO.swift
//  SANPLLibrary
//
import CoreDomain
import Foundation
import CoreFoundationLib

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

extension LoanDetailDTO: LoanDetailRepresentable {
    public var holder: String? {
        return nil
    }
    
    public var initialAmountRepresentable: AmountRepresentable? {
        let amountValue = Decimal(loanAccountDetails?.grantedCreditLimit?.value ?? 0)
        return AmountDTO(value: amountValue, currencyRepresentable: currency)
    }
    
    public var interestType: String? {
        let interestType = String(accountDetails?.interestRate ?? 0) + "%"
        return interestType.replacingOccurrences(of: ".", with: ",", options: .literal, range: nil)
    }
    
    public var interestTypeDesc: String? {
        return nil
    }
    
    public var feePeriodDesc: String? {
        return nil
    }
    
    public var openingDate: Date? {
        Date().parse(accountDetails?.openedDate ?? "", format: .YYYYMMDD)
    }
    
    public var initialDueDate: Date? {
        return nil
    }
    
    public var currentDueDate: Date? {
        Date().parse(loanAccountDetails?.finalRepaymentDate ?? "", format: .YYYYMMDD)
    }
    
    public var linkedAccountContractRepresentable: ContractRepresentable? {
        return nil
    }
    
    public var linkedAccountDesc: String? {
        return nil
    }
    
    public var revocable: Bool? {
        return nil
    }
    
    public var nextInstallmentDate: Date? {
        Date().parse(loanAccountDetails?.nextInstallmentDate ?? "", format: .YYYYMMDD)
    }
    
    public var currentInterestAmount: String? {
        guard let currentInterestAmount = loanAccountDetails?.interest?.previousTotalAmount?.value else {
            return nil
        }
        let currentInterestAmountSt = "\(currentInterestAmount)" + " " + (loanAccountDetails?.grantedCreditLimit?.currencyCode ?? "")
        return currentInterestAmountSt.replacingOccurrences(of: ".", with: ",", options: .literal, range: nil)
    }
    
    public var amortizable: Bool? {
        return nil
    }
    
    public var lastOperationDate: Date? {
        Date().parse(lastUpdate ?? "", format: .YYYYMMDD)
    }
    
    public var formatPeriodicity: String? {
        guard let periodicity = feePeriodDesc else { return nil }
        switch periodicity {
        case "daily":
            return localized("generic_label_daily")
        case "weekly":
            return localized("generic_label_weekly")
        case "every 15 days":
            return localized("generic_label_biweekly")
        case "monthly":
            return localized("generic_label_monthly")
        case "bimonthly":
            return localized("generic_label_bimonthly")
        case "quarterly":
            return localized("generic_label_quarterly")
        case "every four months":
            return localized("generic_label_everyFourMonths")
        case "every five months":
            return localized("generic_label_everyFiveMonths")
        case "every six month":
            return localized("generic_label_biannual")
        case "annual":
            return localized("generic_label_annual")
        case "every three years":
            return localized("generic_label_everyThreeYears")
        case "every five years":
            return localized("generic_label_everyFiveYears")
        case "every 456 months":
            return localized("generic_label_every456Months")
        case "irregular N/A":
            return localized("generic_label_notAvailable")
        default:
            let numMonths = periodicity
                .replace("every", "")
                .replace("months", "")
                .trim()
            if Int(numMonths) != nil {
                return localized("generic_label_everyXXMonths",
                                 [StringPlaceholder(StringPlaceholder.Placeholder.number, numMonths)]).text
            } else {
                return nil
            }
        }
    }
}

private extension LoanDetailDTO {
    var currency: CurrencyRepresentable? {
        guard let currencyCode = loanAccountDetails?.grantedCreditLimit?.currencyCode else {
            return nil
        }
        let currencyType = CurrencyType.parse(currencyCode)
        return CurrencyDTO(currencyName: currencyCode, currencyType: currencyType)
    }
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

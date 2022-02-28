//
//  PLLoanDetailModifier.swift
//  Santander
//
//  Created by Julio Nieto Santiago on 18/8/21.
//

import CoreFoundationLib
import PLLegacyAdapter
import SANPLLibrary
import Loans

final class PLLoanDetailModifier {
    private let managersProvider: PLManagersProviderProtocol
    
    init(dependencies: ModuleDependencies) {
        self.managersProvider = dependencies.resolve()
    }
}

extension PLLoanDetailModifier: LoanDetailModifierProtocol {
    var isEnabledFirstHolder: Bool {
        return false
    }
    
    var isEnabledInitialExpiration: Bool {
        return false
    }
    
    func formatLoanId(_ loanId: String) -> String {
        guard let firstPart = loanId.substring(0, 4) else {
            return ""
        }
        guard let secondPart = loanId.substring(4) else {
            return firstPart
        }
        return "\(firstPart) \(secondPart)"
    }
    
    func formatPeriodicity(_ periodicity: String) -> String? {
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
    
    var aliasIsNeeded: Bool {
        return false
    }
    
    var isEnabledLastOperationDate: Bool {
        return true
    }
    
    var isEnabledNextInstallmentDate: Bool {
        return true
    }
    
    var isEnabledCurrentInterestAmount: Bool {
        return true
    }
}

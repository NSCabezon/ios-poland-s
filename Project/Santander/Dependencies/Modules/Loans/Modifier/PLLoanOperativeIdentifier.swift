//
//  PLLoanOperativeIdentifier.swift
//  Santander
//
//  Created by Alvaro Royo on 17/3/22.
//

import Foundation
import Loans

enum PLLoanOperativeIdentifier: String {
    case details = "LOAN_DETAILS"
    case repayment = "REPAYMENT_SCHEDULE"
    case changeAliases = "CHANGE_ALIAS"
    case customerService = "CUSTOMER_SERVICE"
    
    public var icon: String {
        switch self {
        case .repayment:
            return "icnLoanSchedule"
        case .changeAliases:
            return "icnChangeAlias"
        case .customerService:
            return "icnCustomerService"
        case .details:
            return "icnDetail"
        }
    }
    
    public var textKey: String {
        switch self {
        case .repayment:
            return "loansOption_button_loanSchedule"
        case .changeAliases:
            return "productOption_button_changeAlias"
        case .customerService:
            return "frequentOperative_button_customerService"
        case .details:
            return "accountOption_button_detail"
        }
    }
    
    var type: LoanOptionType {
        switch self {
        case .repayment: return .custom(identifier: "loansOption_button_loanSchedule")
        case .details: return .detail
        case .changeAliases: return .custom(identifier: "change_alias")
        case .customerService: return .custom(identifier: "loansOption_button_customerService")
        }
    }
    
    var order: Int {
        switch self {
        case .repayment: return 0
        case .customerService: return 1
        case .details: return 2
        default: return Int.max
        }
    }
}

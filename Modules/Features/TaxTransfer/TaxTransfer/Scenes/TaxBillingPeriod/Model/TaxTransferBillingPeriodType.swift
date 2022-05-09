//
//  TaxTransferBillingPeriodType.swift
//  TaxTransfer
//
//  Created by 187831 on 03/03/2022.
//

import PLScenes
import CoreFoundationLib

public enum TaxTransferBillingPeriodType: SelectableItem {
    case year
    case halfYear
    case quarter
    case month
    case decade
    case day
    
    public var identifier: String {
        return String(describing: self)
    }
    
    public var name: String {
        switch self {
        case .day:
            return localized("pl_taxTransfer_tab_day")
        case .decade:
            return localized("pl_taxTransfer_tab_decade")
        case .halfYear:
            return localized("pl_taxTransfer_tab_halfYear")
        case .month:
            return localized("pl_taxTransfer_tab_month")
        case .quarter:
            return localized("pl_taxTransfer_tab_quarter")
        case .year:
            return localized("pl_taxTransfer_tab_year")
        }
    }
    
    public var periodNumbers: [Int] {
        switch self {
        case .halfYear:
            return [01, 02]
        case .quarter:
            return [01, 02, 03, 04]
        case .month:
            return [01, 02, 03, 04, 05, 06, 07, 08, 09, 10, 11, 12]
        case .decade:
            return [0101, 0201, 0301,
                    0102, 0202, 0302,
                    0103, 0203, 0303,
                    0104, 0204, 0304,
                    0105, 0205, 0305,
                    0106, 0206, 0306,
                    0107, 0207, 0307,
                    0108, 0208, 0308,
                    0109, 0209, 0309,
                    0110, 0210, 0310,
                    0111, 0211, 0311,
                    0112, 0212, 0312]
        default:
            return []
        }
    }
    
    public var short: String {
        switch self {
        case .year:
            return "R"
        case .halfYear:
            return "P"
        case .quarter:
            return "K"
        case .month:
            return "M"
        case .decade:
            return "D"
        case .day:
            return "J"
        }
    }
    
    public var shouldChoosePeriodNumber: Bool {
        switch self {
        case .year,
             .day:
            return false
        default:
            return true
        }
    }
}

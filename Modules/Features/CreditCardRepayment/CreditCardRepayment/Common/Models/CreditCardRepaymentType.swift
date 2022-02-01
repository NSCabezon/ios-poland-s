import Foundation
import CoreFoundationLib

enum CreditCardRepaymentType {
    case complete
    case minimal
    case other
}

extension CreditCardRepaymentType {
    var localized: String {
        switch self {
        case .complete: return CoreFoundationLib.localized("pl_creditCard_text_repTypeTot")
        case .minimal: return CoreFoundationLib.localized("pl_creditCard_text_repTypeMin")
        case .other: return CoreFoundationLib.localized("pl_creditCard_text_repTypeOther")
        }
    }
}

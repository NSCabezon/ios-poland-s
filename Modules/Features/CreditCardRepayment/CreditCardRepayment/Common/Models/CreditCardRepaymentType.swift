import Foundation
import Commons

enum CreditCardRepaymentType {
    case complete
    case minimal
    case other
}

extension CreditCardRepaymentType {
    var localized: String {
        switch self {
        case .complete: return Commons.localized("pl_creditCard_text_repTypeTot")
        case .minimal: return Commons.localized("pl_creditCard_text_repTypeMin")
        case .other: return Commons.localized("pl_creditCard_text_repTypeOther")
        }
    }
}

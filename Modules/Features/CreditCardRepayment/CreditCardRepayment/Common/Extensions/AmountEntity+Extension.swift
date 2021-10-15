import Foundation
import Models

extension AmountEntity {
    var displayValueAndCurrency: String? {
        guard let value = value, let currency = currency else { return nil }
        return value.description + " " + currency
    }
}

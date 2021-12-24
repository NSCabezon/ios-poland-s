import Foundation
import CoreFoundationLib

extension AmountEntity {
    var displayValueAndCurrency: String? {
        guard let value = value, let currency = currency else { return nil }
        return value.description + " " + currency
    }
    
    func getFormattedDisplayValueAndCurrency(with numberFormatter: NumberFormatter) -> String? {
        guard let value = value, let currency = currency else { return nil }
        
        let formattedValue = numberFormatter.string(for: value) ?? "\(value)"
        return formattedValue + " " + currency
    }
}

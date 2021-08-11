//
//  PercentAdapter.swift
//  PLLegacyAdapter
//

import SANLegacyLibrary
import SANPLLibrary

public final class PercentAdapter {
    public static func adaptValueToPercentPresentation(_ value: Double?) -> String? {
        guard let value = value else {
            return nil
        }
        let formatter = NumberFormatter()
        formatter.groupingSeparator = ""
        formatter.decimalSeparator = ","
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        formatter.numberStyle = .decimal
        if let valueString = formatter.string(from: value as NSNumber) {
            return valueString + "%"
        }
        return nil
    }
}

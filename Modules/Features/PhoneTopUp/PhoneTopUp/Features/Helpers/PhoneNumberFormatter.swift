//
//  FullPhoneNumberFormatter.swift
//  PhoneTopUp
//
//  Created by 188216 on 04/04/2022.
//

import Foundation
import PLCommons

final class PhoneNumberFormatter {
    // MARK: Properties
    
    private let polandPrefix = "+48"
    
    // MARK: Methods

    func formatPhoneNumberText(_ text: String) -> String {
        let textWithoutWhitespace = text.replace(" ", "")
        let formattedNumber = textWithoutWhitespace.separated(by: " ", stride: 3)
        return "\(polandPrefix) \(formattedNumber)"
    }
}

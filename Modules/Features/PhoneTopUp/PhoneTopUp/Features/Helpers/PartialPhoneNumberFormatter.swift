//
//  PartialPhoneNumberFormatter.swift
//  PhoneTopUp
//
//  Created by 188216 on 01/12/2021.
//

import Foundation
import PLCommons

final class PartialPhoneNumberFormatter {
    // MARK: Lifecycle
    
    init() {
    }
    
    // MARK: Methods

    func formatPhoneNumberText(_ text: String) -> String {
        let textWithoutWhitespace = text.replace(" ", "")
        return textWithoutWhitespace.separated(by: " ", stride: 3)
    }
}

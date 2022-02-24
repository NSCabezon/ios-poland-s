//
//  PartialPhoneNumberValidator.swift
//  PhoneTopUp
//
//  Created by 188216 on 01/12/2021.
//

import Foundation

enum ValidationResults {
    case invalid
    case partiallyValid(number: String)
    case valid(number: String)
}

protocol PartialPhoneNumberValidating {
    func validatePhoneNumberText(_ text: String) -> ValidationResults
}

final class PartialPhoneNumberValidator: PartialPhoneNumberValidating {
    
    // MARK: Properties
    
    private let maxNumberOfDigits = 9
    private let maxNumberOfWhitespace = 2
    private var maxNumberOfCharacters: Int {
        return maxNumberOfDigits + maxNumberOfWhitespace
    }
    
    // MARK: Methods
    
    func validatePhoneNumberText(_ text: String) -> ValidationResults {
        guard text.count <= maxNumberOfCharacters, text.count >= 0 else {
            return .invalid
        }
        let textWithoutWhitespace = text.replace(" ", "")
        let isTextAllNumbers = textWithoutWhitespace.allSatisfy(\.isNumber)
        if isTextAllNumbers && textWithoutWhitespace.count < maxNumberOfDigits {
            return .partiallyValid(number: textWithoutWhitespace)
        } else if isTextAllNumbers && textWithoutWhitespace.count == maxNumberOfDigits {
            return .valid(number: textWithoutWhitespace)
        } else {
            return .invalid
        }
    }
}

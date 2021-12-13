//
//  PartialPhoneNumberValidator.swift
//  PhoneTopUp
//
//  Created by 188216 on 01/12/2021.
//

import Foundation

final class PartialPhoneNumberValidator {
    // MARK: Properties
    
    private let maxNumberOfDigits = 9
    private let maxNumberOfWhitespace = 2
    private var maxNumberOfCharacters: Int {
        return maxNumberOfDigits + maxNumberOfWhitespace
    }
    
    // MARK: Lifecycle
    
    init() {
    }
    
    // MARK: Methods
    
    func validatePhoneNumberText(_ text: String) -> Bool {
        guard text.count <= maxNumberOfCharacters else {
            return false
        }
        let textWithoutWhitespace = text.replace(" ", "")
        let isTextAllNumbers = textWithoutWhitespace.allSatisfy(\.isNumber)
        return isTextAllNumbers && textWithoutWhitespace.count <= maxNumberOfDigits
    }
}

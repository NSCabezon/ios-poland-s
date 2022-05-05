//
//  TaxIdentifierValidator.swift
//  TaxTransfer
//
//  Created by 187831 on 28/04/2022.
//

import Foundation
import CoreFoundationLib

protocol TaxIdentifierValidating {
    func validate(type: TaxIdentifierType, value: String) -> TaxIdentifierValidatonResult
}

final class TaxIdentifierValidator: TaxIdentifierValidating {
    func validate(type: TaxIdentifierType, value: String) -> TaxIdentifierValidatonResult {
        guard !value.isEmpty else {
            return .invalid(localized("pl_generic_validationText_thisFieldCannotBeEmpty"))
        }
        
        guard value.matches(type.regex) else {
            return .invalid(type.errorMessage)
        }
        
        let invalidValueMessage = getIdentifierNumberValidationMessage(type: type, value: value)
        let isValid = invalidValueMessage == nil
        
        guard isValid else {
            return .invalid(invalidValueMessage)
        }
        
        return .valid
    }
}

private extension TaxIdentifierValidator {
    func getIdentifierNumberValidationMessage(
        type: TaxIdentifierType,
        value: String
    ) -> String? {
        switch type {
        case .PESEL,
             .NIP:

            if isChecksumValid(type: type, value: value) {
                return nil
            } else {
                return type.errorMessage
            }
        default:
            return nil
        }
    }

    func isChecksumValid(type: TaxIdentifierType, value: String) -> Bool {
        guard let checksumIndex = type.checksumIndex,
              let moduloValue = type.moduloValue,
              let isComplementValue = type.isComplementValue,
              let checksumValue = value[safe: checksumIndex] else {
            return false
        }
        
        let controlSum = Int(checksumValue)

        var sum = 0
        
        for (index, _) in value.enumerated() {
            if let charValue = Int(value[index]),
               let weight = type.weights.element(atIndex: index) {
                sum += Int(charValue) * weight
            }
        }
        
        var control = sum % moduloValue
        
        if isComplementValue {
            control = type.complementValue - control
        }
        
        control = control % 10
        
        return control == controlSum
    }
}

//
//  AddTaxPayerFormValidator.swift
//  TaxTransfer
//
//  Created by 187831 on 03/02/2022.
//

import CoreFoundationLib

protocol AddTaxPayerFormValidating {
    func validate(_ form: AddTaxPayerForm) -> AddTaxPayerFormValidationResult
}

final class AddTaxPayerFormValidator: AddTaxPayerFormValidating {
    private struct Constants {
        static let payerNameRegex = "^([0-9A-Za-ząęćółńśżźĄĘĆÓŁŃŚŻŹ\\-.:;,& ]*)$"
    }
    
    private let type: TaxIdentifierType
    
    init(type: TaxIdentifierType) {
        self.type = type
    }
    
    func validate(_ form: AddTaxPayerForm) -> AddTaxPayerFormValidationResult {
        let invalidIdentifierNumber = getIdentifierNumberValidationMessage(form.identifierNumber)
        let invalidPayerName = getNameValidationMessage(form.payerName)
        let isFormValid = invalidPayerName == nil && invalidIdentifierNumber == nil
        
        guard isFormValid else {
            let messages = InvalidAddTaxPayerFormMessages(
                invalidNameMessage: invalidPayerName,
                invalidIdentifierNumberMessage: invalidIdentifierNumber
            )
            return .invalid(messages)
        }
        
        return .valid
    }
    
    private func getIdentifierNumberValidationMessage(_ number: String) -> String? {
        guard !number.isEmpty else {
            return nil
        }

        if number.matches(type.regex) {
            return checkSumIfNeeded(value: number)
        } else {
            return localized(type.errorMessage)
        }
    }
    
    private func getNameValidationMessage(_ name: String) -> String? {
        guard !name.isEmpty else {
            return nil
        }
        
        if name.matches(Constants.payerNameRegex) {
            return nil
        } else {
            return localized("pl_taxTransfer_validation_forbiddenCharacter")
        }
    }
    
    private func checkSumIfNeeded(value: String) -> String? {
        switch type {
        case .PESEL,
             .NIP:
            
            if isChecksumValid(value: value) {
                return nil
            } else {
                return type.errorMessage
            }
        default:
            return nil
        }
    }
    
    private func isChecksumValid(value: String) -> Bool {
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

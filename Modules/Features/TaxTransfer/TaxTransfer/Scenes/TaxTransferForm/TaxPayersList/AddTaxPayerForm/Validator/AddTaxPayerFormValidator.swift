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
    
    private let validator: TaxIdentifierValidating
    
    init(dependenciesResolver: DependenciesResolver) {
        self.validator = dependenciesResolver.resolve(for: TaxIdentifierValidating.self)
    }
    
    func validate(_ form: AddTaxPayerForm) -> AddTaxPayerFormValidationResult {
        let invalidIdentifierNumber = validator.validate(
            type: form.identifierType,
            value: form.identifierNumber
        )
        let invalidPayerName = getNameValidationMessage(form.payerName)        
        let invalidIdentifierNumberMessage: String?
        
        switch invalidIdentifierNumber {
        case .valid:
            invalidIdentifierNumberMessage = nil
        case let .invalid(message):
            invalidIdentifierNumberMessage = message
        }
        
        let isFormValid = invalidPayerName == nil && invalidIdentifierNumberMessage == nil
        
        guard isFormValid else {
            let messages = InvalidAddTaxPayerFormMessages(
                invalidNameMessage: invalidPayerName,
                invalidIdentifierNumberMessage: invalidIdentifierNumberMessage
            )
            return .invalid(messages)
        }
        
        return .valid
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
}

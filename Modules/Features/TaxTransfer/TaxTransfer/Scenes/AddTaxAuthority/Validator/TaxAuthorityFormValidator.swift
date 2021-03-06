//
//  TaxAuthorityFormValidator.swift
//  TaxTransfer
//
//  Created by 185167 on 06/04/2022.
//

import CoreFoundationLib

enum TaxAuthorityFormValidationResult {
    case valid
    case invalid(InvalidTaxAuthorityFormFormMessages)
}
        
struct InvalidTaxAuthorityFormFormMessages {
    let invalidTaxAuthorityNameMessage: String?
    let invalidAccountNumberMessage: String?
}

protocol TaxAuthorityFormValidating {
    func validate(_ form: TaxAuthorityForm) -> TaxAuthorityFormValidationResult
}

final class TaxAuthorityFormValidator: TaxAuthorityFormValidating {
    private let accountTypeRecognizer: TaxAccountTypeRecognizing
    
    init(accountTypeRecognizer: TaxAccountTypeRecognizing) {
        self.accountTypeRecognizer = accountTypeRecognizer
    }
    
    func validate(_ form: TaxAuthorityForm) -> TaxAuthorityFormValidationResult {
        switch form {
        case .formTypeUnselected:
            return invalidResultWithEmptyMessages
        case let .us(form):
            return validateUsForm(form)
        case let .irp(form):
            return validateIrpForm(form)
        }
    }
}

private extension TaxAuthorityFormValidator {
    struct Constants {
        static let taxAuthorityNameValidationRegex = "^([0-9A-Za-ząęćółńśżźĄĘĆÓŁŃŚŻŹ\\-.:;,& ]*)$"
    }
    
    var invalidResultWithEmptyMessages: TaxAuthorityFormValidationResult {
        return .invalid(
            InvalidTaxAuthorityFormFormMessages(
                invalidTaxAuthorityNameMessage: nil,
                invalidAccountNumberMessage: nil
            )
        )
    }
    
    func validateUsForm(_ form: UsTaxAuthorityForm) -> TaxAuthorityFormValidationResult {
        guard
            let cityName = form.city,
            let _ = form.taxAuthorityAccount,
            cityName.isNotEmpty
        else {
            return invalidResultWithEmptyMessages
        }
        
        return .valid
    }
    
    func validateIrpForm(_ form: IrpTaxAuthorityForm) -> TaxAuthorityFormValidationResult {
        let accountNumber = form.accountNumber?.filter { !$0.isWhitespace }
        let invalidTaxAuthorityNameMessage = getInvalidTaxAuthorityNameMessageIfNeeded(for: form.taxAuthorityName)
        let invalidAccountNumberMessage = getInvalidAccountNumberMessageIfNeeded(for: accountNumber)
        
        let anyFormElementIsInvalid = !invalidTaxAuthorityNameMessage.isNil || !invalidAccountNumberMessage.isNil
        if anyFormElementIsInvalid {
            return .invalid(
                InvalidTaxAuthorityFormFormMessages(
                    invalidTaxAuthorityNameMessage: invalidTaxAuthorityNameMessage,
                    invalidAccountNumberMessage: invalidAccountNumberMessage
                )
            )
        }
        
        let anyFormElementIsEmpty = (accountNumber ?? "").isEmpty || (form.taxAuthorityName ?? "").isEmpty
        if anyFormElementIsEmpty {
            return invalidResultWithEmptyMessages
        }
        
        return .valid
    }
    
    func getInvalidTaxAuthorityNameMessageIfNeeded(for taxAuthorityName: String?) -> String? {
        guard let taxAuthorityName = taxAuthorityName else {
            return nil
        }
        
        guard taxAuthorityName.matches(Constants.taxAuthorityNameValidationRegex) else {
            return localized("pl_taxTransfer_validation_forbiddenCharacter")
        }
        
        return nil
    }
    
    func getInvalidAccountNumberMessageIfNeeded(for accountNumber: String?) -> String? {
        guard let accountNumber = accountNumber else {
            return nil
        }
        
        guard accountNumber.count > 25 else {
            return localized("pl_generic_validationText_upTo26Characters")
        }
        
        guard CharacterSet(charactersIn: accountNumber).isSubset(of: CharacterSet.decimalDigits) else {
            return localized("pl_taxTransfer_validation_forbiddenCharacter")
        }
        
        guard
            let accountType = try? accountTypeRecognizer.recognizeType(of: accountNumber),
            accountType == .IRP
        else {
            return localized("pl_generic_validationText_invalidAccNumber")
        }
        
        return nil
    }
}

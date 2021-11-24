//
//  AliasNameValidator.swift
//  BLIK
//
//  Created by 187830 on 19/11/2021.
//

import Commons

protocol AliasNameValidatorProtocol {
    func validate(_ name: String?) -> AliasnNameValidationResult
}

final class AliasNameValidator: AliasNameValidatorProtocol {

    private let aliastNamelLimit: Decimal
    init(
        aliastNamelLimit: Decimal = 20
    ) {
        self.aliastNamelLimit = aliastNamelLimit
    }
    
    func validate(_ name: String?) -> AliasnNameValidationResult {
        let invalidNameMessage: String? = getNameValidationMessage(name)
        let isNameValid = invalidNameMessage == nil
        if  isNameValid {
            return .valid
        }
        return .invalid(.init(invalidNameMessage: invalidNameMessage))
    }
        
    private func getNameValidationMessage(_ name: String?) -> String? {
        guard let name = name, !name.isEmpty else {
            return localized("pl_blikSett_text_validEmptyField")
        }
        do {
            if try checkForIllegalCharacters(in: name) {
                return localized("pl_blik_text_validName")
            }
            if name.count > 20 {
                return localized("pl_blik_text_aliasMaxSign")
            }
        } catch {
            return localized("generic_alert_title_errorData")
        }
        
        return nil
    }
    
    private func checkForIllegalCharacters(in text: String) throws -> Bool {
        let regexText = "^[0-9A-Za-ząęćółńśżźĄĘĆÓŁŃŚŻŹ\\-\\.\\:\\;, ]+$"
        let regex = try NSRegularExpression(pattern: regexText)
        let range = NSRange(location: 0, length: text.utf16.count)
        return regex.firstMatch(in: text, options: [], range: range) == nil
    }
}

//
//  TaxTransferFormValidator.swift
//  TaxTransfer
//
//  Created by 185167 on 05/01/2022.
//

import CoreFoundationLib

protocol TaxTransferFormValidating {
    func validateFields(_ fields: TaxTransferFormFields) -> TaxTransferFormValidity
}

final class TaxTransferFormValidator: TaxTransferFormValidating {
    private let amountFormatter: NumberFormatter
    private let minimalAmount = 0.01
    
    init(amountFormatter: NumberFormatter) {
        self.amountFormatter = amountFormatter
    }
    
    enum Error: Swift.Error {
        case illegalCharacters
    }
    
    func validateFields(_ fields: TaxTransferFormFields) -> TaxTransferFormValidity {
        let invalidObligationIdentifierMessage = validateObligationIdentifier(fields.obligationIdentifier)
        let invalidAmountMessage = validateAmount(fields.amount)
        
        if invalidObligationIdentifierMessage != nil || invalidAmountMessage != nil {
            let invalidStateMessages = TaxTransferFormValidity.InvalidFormMessages(
                amountMessage: invalidAmountMessage,
                obligationIdentifierMessage: invalidObligationIdentifierMessage
            )
            return .invalid(invalidStateMessages)
        }
        
        if fields.amount.isEmpty {
            let emptyMessages = TaxTransferFormValidity.InvalidFormMessages(
                amountMessage: nil,
                obligationIdentifierMessage: nil
            )
            return .invalid(emptyMessages)
        }
        
        return .valid
    }
}

private extension TaxTransferFormValidator {
    func validateObligationIdentifier(_ identifier: String) -> String? {
        if identifier.isEmpty {
            return nil
        }
        do {
            let isIdentifierIllegal = try checkForIllegalCharacters(in: identifier)
            if isIdentifierIllegal {
                throw Error.illegalCharacters
            } else {
                return nil
            }
        } catch {
            return localized("pl_taxTransfer_validationText_InvalidFinancialObligationId")
        }
    }
    
    func validateAmount(_ amount: String) -> String? {
        guard let amount = getAmountAsDouble(amount) else {
            return nil
        }
        guard amount >= minimalAmount else {
            return localized("pl_generic_validationText_amountMoreThan0")
        }
        return nil
    }
    
    func checkForIllegalCharacters(in text: String) throws -> Bool {
        let regexText = "^([0-9A-Za-ząęćółńśżźĄĘĆÓŁŃŚŻŹ\\-.:;,& ]*)$"
        let regex = try NSRegularExpression(pattern: regexText)
        let range = NSRange(location: 0, length: text.utf16.count)
        return regex.firstMatch(in: text, options: [], range: range) == nil
    }
    
    func getAmountAsDouble(_ amount: String) -> Double? {
        if let amount = amountFormatter.number(from: amount) {
            return Double(truncating: amount)
        }
        return Double(amount) // amount formatter have problems with parsing numbers that aren't in format x,xx
    }
}

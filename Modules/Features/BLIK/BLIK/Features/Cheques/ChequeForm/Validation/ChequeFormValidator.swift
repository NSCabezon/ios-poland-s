//
//  ChequeFormValidator.swift
//  BLIK
//
//  Created by Piotr Mielcarzewicz on 14/07/2021.
//

import Commons

protocol ChequeFormValidating {
    func validate(_ form: ChequeForm) -> ChequeFormValidationResult
}

final class ChequeFormValidator: ChequeFormValidating {
    private let amountLimit: Decimal
    private let currency: String
    private let amountFormatter: NumberFormatter
    
    init(
        amountLimit: Decimal,
        currency: String,
        amountFormatter: NumberFormatter
    ) {
        self.amountLimit = amountLimit
        self.currency = currency
        self.amountFormatter = amountFormatter
    }
    
    func validate(_ form: ChequeForm) -> ChequeFormValidationResult {
        let invalidAmountMessage = getAmountValidationMessage(form.amount, currency: form.currency)
        let invalidNameMessage: String? = getNameValidationMessage(form.name)
        let isFormValid = (invalidAmountMessage == nil) && (invalidNameMessage == nil)
        
        guard isFormValid else {
            let messages = InvalidChequeFormMessages(
                invalidAmountMessage: invalidAmountMessage,
                invalidNameMessage: invalidNameMessage
            )
            return .invalid(messages)
        }
        
        guard let amount = Decimal(string: form.amount) else {
            let messages = InvalidChequeFormMessages(
                invalidAmountMessage: localized("pl_blik_text_cheque_emptyField"),
                invalidNameMessage: nil
            )
            return .invalid(messages)
        }
        
        let formRequest = CreateChequeRequest(
            ticketTime: form.expirationPeriod.rawValue,
            ticketName: form.name,
            ticketAmount: amount,
            ticketCurrency: form.currency
        )
        return .valid(formRequest)
    }
    
    private func getAmountValidationMessage(_ amount: String, currency: String) -> String? {
        guard let amount = Decimal(string: amount) else {
            return localized("pl_blik_text_cheque_emptyField")
        }
        
        if amount <= 0 {
            return localized("pl_blik_text_validAmount")
        }
        
        if amount > amountLimit {
            amountFormatter.currencySymbol = currency
            let formattedAmount = amountFormatter.string(for: amountLimit) ?? "\(amountLimit) \(currency)"
            return localized("pl_blik_text_cheque_lessOrEqual", [StringPlaceholder(.value, formattedAmount)]).text
        }
        
        return nil
    }
    
    private func getNameValidationMessage(_ name: String) -> String? {
        if name.count == 0 {
            return nil
        }
        
        do {
            if try checkForIllegalCharacters(in: name) {
                return localized("pl_blik_text_validName")
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

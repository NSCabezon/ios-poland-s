import CoreFoundationLib
import PLCommons

protocol SplitPaymentValidating {
    func validateForm(
        form: SplitPaymentFormViewModel,
        with currentActivefield: TransferFormCurrentActiveField
    ) -> InvalidSplitPaymentFormData
    
    func getAccountRequiredLength() -> Int
}

struct SplitPaymentValidator: SplitPaymentValidating {
    private let accountRequiredLength: Int
    private let maxGrossTransferAmmount: Decimal
    private let maxVatRate: Int
    private var bankingUtils: BankingUtilsProtocol
    private let validator: PLValidatorProtocol
    private struct Constants {
        static let countryCode = "PL"
        static let invoiceValidationRegex = "^([0-9A-Za-ząęćółńśżźĄĘĆÓŁŃŚŻŹ\\-.:;,& ]*)$"
        static let nipValidationRegex = "^\\d{10}$"
    }
    
    init(dependenciesResolver: DependenciesResolver,
         accountRequiredLength: Int = 26,
         maxGrossTransferAmmount: Decimal = 100_000,
         maxVatRate: Int = 23,
         validator: PLValidatorProtocol) {
        bankingUtils = dependenciesResolver.resolve()
        self.accountRequiredLength = accountRequiredLength
        self.maxGrossTransferAmmount = maxGrossTransferAmmount
        self.maxVatRate = maxVatRate
        self.validator = validator
    }
    
    func validateForm(
        form: SplitPaymentFormViewModel,
        with currentActiveField: TransferFormCurrentActiveField
    ) -> InvalidSplitPaymentFormData {
        InvalidSplitPaymentFormData(invalidRecieptMessages: validateText(form.recipient),
                                    invalidAccountMessages: validateAccount(
                                        form.recipientAccountNumber,
                                        currentActiveField: currentActiveField
                                    ),
                                    invalidNipAmountMessages: validateNip(form.nip),
                                    invalidGrossAmountMessages: validateGrossAmount(form.grossAmount),
                                    invalidVatAmountMessages: validateVatAmount(form.vatAmount, grossAmount: form.grossAmount),
                                    invalidInvoiceTitleMessages: validateInvoice(form.invoiceTitle),
                                    invalidTitleMessages: validateTitle(form.title),
                                    currentActiveField: currentActiveField)
    }
    
    func getAccountRequiredLength() -> Int {
        accountRequiredLength
    }
}

private extension SplitPaymentValidator {
    
    func validateAccount(_ account: String?,
                         currentActiveField: TransferFormCurrentActiveField) -> String? {
        guard let account = account, !account.isEmpty else {
            return localized("pl_generic_validationText_thisFieldCannotBeEmpty").text
        }

        if case let .accountNumber(controlEvent) = currentActiveField,
           controlEvent == .endEditing {
            if account.count < accountRequiredLength {
                return localized("pl_generic_validationText_upTo26Characters").text
            } else if account.count > accountRequiredLength {
                return localized("pl_generic_validationText_invalidAccNumber").text
            }
        }
        
        if account.count == accountRequiredLength {
            if !isValidIban(account) {
                return localized("pl_generic_validationText_invalidAccNumber").text
            }
        }
        return nil
    }
    
    func validateGrossAmount(_ amount: Decimal?) -> String? {
        guard let amount = amount else {
            return localized("pl_generic_validationText_thisFieldCannotBeEmpty").text
        }
        if amount <= 0 {
            return localized("pl_generic_validationText_amountMoreThan0").text
        } else if amount > maxGrossTransferAmmount  {
            return localized("pl_generic_validationText_amountLessThan100000").text
        }
        return nil
    }
    
    func validateVatAmount(_ vatAmount: Decimal?, grossAmount: Decimal?) -> String? {
        guard let grossAmount = grossAmount else {
            return localized("pl_generic_validationText_thisFieldCannotBeEmpty").text
        }
        guard let vatAmount = vatAmount else {
            return localized("pl_generic_validationText_thisFieldCannotBeEmpty").text
        }
        if grossAmount <= 0 {
            return localized("pl_generic_validationText_amountMoreThan0").text
        } else if vatAmount <= 0 {
            return localized("pl_generic_validationText_amountMoreThan0").text
        } else if vatAmount >= Decimal(maxVatRate) * grossAmount {
            return localized("pl_generic_validationText_amountLessThan100000").text
        }
        
        return nil
    }
    
    func validateInvoice(_ text: String?) -> String? {
        guard let text = text, !text.isEmpty else {
            return localized("pl_generic_validationText_thisFieldCannotBeEmpty").text
        }
        
        if text.count > 35 {
            return localized("pl_split_payment_invoice_title_max_length_error").text
        }
        
        if !text.matches(Constants.invoiceValidationRegex) {
            return localized("pl_split_payment_title_illegal_characters_error")
        }
        
        return nil
    }
    
    func validateNip(_ text: String?) -> String? {
        let result = validator.validateIdentificationNumber(text)
        switch result {
        case .success:
            return nil
        case .failure(let error):
            var errorMessage = "#pl_split_payment_nip_error"
            switch error {
            case PLIdentificationNumberError.invalidType:
                errorMessage = "#pl_split_payment_nip_invalid_type_error"
            case PLIdentificationNumberError.illegalCharacter:
                errorMessage = "#pl_split_payment_nip_invalid_illegal_character_error"
            case PLIdentificationNumberError.invalidLength:
                errorMessage = "#pl_split_payment_nip_invalid_length_error"
            case PLIdentificationNumberError.empty:
                errorMessage = "#pl_split_payment_nip_empty_error"
            case PLIdentificationNumberError.invalidCheckSum:
                errorMessage = "#pl_split_payment_nip_invalid_error"
            }
            
            return errorMessage
        }
    }
    
    func validateText(_ text: String?) -> String? {
        guard let text = text, !text.isEmpty else {
            return localized("pl_generic_validationText_thisFieldCannotBeEmpty").text
        }
        return nil
    }
    
    private func validateTitle(_ title: String?) -> String? {
        guard let text = title, !text.isEmpty else {
            return nil
        }
        
        if text.count > 33 {
            return localized("pl_split_payment_title_max_length_error")
        }
        
        do {
            if try checkForIllegalCharacters(in: text) {
                return localized("pl_split_payment_title_illegal_characters_error")
            }
        } catch {
            return localized("generic_alert_title_errorData")
        }
        
        return nil
    }
    
    func isValidIban(_ account: String) -> Bool {
        if let checkDigitCandidate = account.substring(0, 2), isNumber(checkDigitCandidate) {
            return bankingUtils.isValidIban(ibanString: [Constants.countryCode, account].joined())
        }
        return bankingUtils.isValidIban(ibanString: account)
    }
    
    func isNumber(_ value: String) -> Bool {
        CharacterSet.numbers.isSuperset(of: CharacterSet(charactersIn: value))
    }
}

private extension SplitPaymentValidator {
    
    private func checkForIllegalCharacters(in text: String) throws -> Bool {
        let regexText = "^([0-9A-Za-ząęćółńśżźĄĘĆÓŁŃŚŻŹ\\-.:;,& ]*)$"
        let regex = try NSRegularExpression(pattern: regexText)
        let range = NSRange(location: 0, length: text.utf16.count)
        return regex.firstMatch(in: text, options: [], range: range) == nil
    }

}

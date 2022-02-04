import Commons

private enum Constants {
    static let countryCode = "PL"
}

protocol ZusTransferValidating {
    func validateForm(
        form: ZusTransferFormViewModel,
        with currentActivefield: TransferFormCurrentActiveField,
        maskAccount: String
    ) -> InvalidZusTransferFormData
}

struct ZusTransferValidator: ZusTransferValidating {
    private let accountRequiredLength: Int
    private let maxTransferAmmount: Decimal
    private var bankingUtils: BankingUtilsProtocol
    
    init(dependenciesResolver: DependenciesResolver,
         accountRequiredLength: Int = 26,
         maxTransferAmmount: Decimal = 100_000) {
        bankingUtils = dependenciesResolver.resolve()
        self.accountRequiredLength = accountRequiredLength
        self.maxTransferAmmount = maxTransferAmmount
    }
    
    func validateForm(
        form: ZusTransferFormViewModel,
        with currentActiveField: TransferFormCurrentActiveField,
        maskAccount: String
    ) -> InvalidZusTransferFormData {
        InvalidZusTransferFormData(
            invalidRecieptMessages: validateText(form.recipient),
            invalidAccountMessages: validateAccount(
                form.recipientAccountNumber,
                maskAccount: maskAccount,
                currentActiveField: currentActiveField
            ),
            invalidAmountMessages: validateAmount(form.amount),
            invalidTitleMessages: validateText(form.title),
            currentActiveField: currentActiveField
        )
    }
}

private extension ZusTransferValidator {
    
    func validateAccount(_ account: String?,
                         maskAccount: String,
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
        
        if account.count == accountRequiredLength, let accountSubstring = account.substring(2, 13) {
            if accountSubstring != maskAccount || !isValidIban(account) {
                return localized("pl_generic_validationText_invalidAccNumber").text
            }
        }
        return nil
    }
    
    func validateAmount(_ amount: Decimal?) -> String? {
        guard let amount = amount else {
            return localized("pl_generic_validationText_thisFieldCannotBeEmpty").text
        }
        if amount <= 0 {
            return localized("pl_generic_validationText_amountMoreThan0").text
        } else if amount > maxTransferAmmount  {
            return localized("pl_generic_validationText_amountLessThan100000").text
        }
        return nil
    }
    
    func validateText(_ text: String?) -> String? {
        guard let text = text, !text.isEmpty else {
            return localized("pl_generic_validationText_thisFieldCannotBeEmpty").text
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

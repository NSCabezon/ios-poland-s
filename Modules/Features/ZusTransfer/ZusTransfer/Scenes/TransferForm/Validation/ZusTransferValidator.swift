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
            #warning("should be changed")
            return "#Pole nie może być puste"
        }

        if case let .accountNumber(controlEvent) = currentActiveField,
           controlEvent == .endEditing, account.count < accountRequiredLength  {
            #warning("should be changed")
            return "#Minimalna liczba znaków wynosi 26"
        }
        
        if account.count == accountRequiredLength, let accountSubstring = account.substring(2, 13) {
            if accountSubstring != maskAccount || !isValidIban(account) {
                #warning("should be changed")
                return "#Podany numer rachunku nie jest poprawny"
            }
        }
        return nil
    }
    
    func validateAmount(_ amount: Decimal?) -> String? {
        guard let amount = amount else {
            #warning("should be changed")
            return "#Pole nie może być puste"
        }
        if amount <= 0 {
            #warning("should be changed")
            return "#Wprowadzona kwota musi być większa od zera"
        } else if amount > maxTransferAmmount  {
            #warning("should be changed")
            return "#Podana kwota jest większa od maksymalnej dopuszczalnej kwoty"
        }
        return nil
    }
    
    func validateText(_ text: String?) -> String? {
        #warning("should be changed")
        let message = "#Pole nie może być puste"
        guard let text = text, !text.isEmpty else {
            return message
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

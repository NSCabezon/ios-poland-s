
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
    
    init(accountRequiredLength: Int = 26, maxTransferAmmount: Decimal = 100_000) {
        self.accountRequiredLength = accountRequiredLength
        self.maxTransferAmmount = maxTransferAmmount
    }
    
    func validateForm(
        form: ZusTransferFormViewModel,
        with currentActivefield: TransferFormCurrentActiveField,
        maskAccount: String
    ) -> InvalidZusTransferFormData {
        InvalidZusTransferFormData(
            invalidRecieptMessages: validateText(form.recipient),
            invalidAccountMessages: validateAccount(form.recipientAccountNumber, maskAccount: maskAccount),
            invalidAmountMessages: validateAmount(form.amount),
            invalidTitleMessages: validateText(form.title),
            currentActiveField: currentActivefield
        )
    }
}

private extension ZusTransferValidator {
    
    func validateAccount(_ account: String?, maskAccount: String) -> String? {
        guard let account = account, !account.isEmpty else {
            #warning("should be changed")
            return "#Pole nie może być puste"
        }
        if account.count < accountRequiredLength {
            #warning("should be changed")
            return "#Minimalna liczba znaków wynosi 26"
        }
        
        if account.count == accountRequiredLength, let accountSubstring = account.substring(2, 13) {
            if accountSubstring != maskAccount && !maskAccount.isEmpty {
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
}

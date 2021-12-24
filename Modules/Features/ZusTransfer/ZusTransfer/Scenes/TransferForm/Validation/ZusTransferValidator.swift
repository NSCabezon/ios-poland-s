
protocol ZusTransferValidating {
    func validateForm(form: ZusTransferFormViewModel) -> InvalidZusTransferFormMessages
}

struct ZusTransferValidator: ZusTransferValidating {
    func validateForm(form: ZusTransferFormViewModel) -> InvalidZusTransferFormMessages {
        var tooLowAmount: String?
        var tooMuchAmount: String?
        if let amount = form.amount, amount <= 0 {
            #warning("should be changed")
            tooLowAmount = "#Wprowadzona kwota musi być większa od zera"
        }
        if let amount = form.amount, amount > 100_000 {
            #warning("should be changed")
            tooMuchAmount = "#Podana kwota jest większa od maksymalnej dopuszczalnej kwoty"
        }
        return InvalidZusTransferFormMessages(
            tooLowAmount: tooLowAmount,
            tooMuchAmount: tooMuchAmount
        )
    }
}

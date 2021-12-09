
import Foundation

struct CharityTransferValidator {
    
    func  validateForm(form: CharityTransferFormViewModel) -> InvalidCharityTransferFormMessages {
        var tooLowAmount: String?
        var tooMuchAmount: String?
        if let amount = form.amount, amount <= 0 {
            tooLowAmount = "#Wprowadzona kwota musi być większa od zera"
        }
        if let amount = form.amount, amount > 100_000 {
            tooMuchAmount = "Podana kwota jest większa od maksymalnej dopuszczalnej kwoty"
        }
        return InvalidCharityTransferFormMessages(tooLowAmount: tooLowAmount,
                                                  tooMuchAmount: tooMuchAmount)
    }
}

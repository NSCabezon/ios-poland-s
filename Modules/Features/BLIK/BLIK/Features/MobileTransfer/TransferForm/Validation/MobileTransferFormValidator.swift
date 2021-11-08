import Foundation

struct MobileTransferFormValidator {
    
    func validateForm(form: MobileTransferForm, validateNumber: Bool) -> InvalidTransferFormMessages {
        var toShortNumberMessage: String?
        var tooLowAmount: String?
        var tooMuchAmount: String?
        if validateNumber, let phoneNumber = form.phoneNumber, phoneNumber.count < 9 {
            if phoneNumber.isEmpty {
                toShortNumberMessage = "#Pole nie może być puste"
            } else {
                toShortNumberMessage = "#Minimalna liczba znaków wynosi 9"
            }
        }
        if let amount = form.amount, amount < 0.02 {
            tooLowAmount = "#Kwota minimalna przelewu na telefon wynosi 0,02 PLN"
        }
        if let amount = form.amount, amount > 100000 {
            tooMuchAmount = "#Podana kwota jest większa od maksymalnej dopuszczalnej kwoty"
        }
        return InvalidTransferFormMessages(tooShortPhoneNumberMessage: toShortNumberMessage, tooLowAmount: tooLowAmount, tooMuchAmount: tooMuchAmount)
    }
}
